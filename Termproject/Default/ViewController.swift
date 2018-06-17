//
//  ViewController.swift
//  HospitalMap
//
//  Created by kpugame on 2018. 4. 23..
//  Copyright © 2018년 SeokJinHo. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var titleText: UITextView!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    
    private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @IBAction func pushButton(_ sender: Any) {
        let startX: CGFloat = 300
        let startY: CGFloat = 0
        let endY: CGFloat = 10
        
        let stars = StardustView(frame: CGRect(x: startX, y:startY, width: 10, height: 10))
        self.view.addSubview(stars)
        self.view.sendSubview(toBack: stars)
        
        UIView.animate(withDuration: 3.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            stars.center = CGPoint(x: startX, y: endY)},
                       completion: {(value:Bool)in stars.removeFromSuperview() })
        
        audioController.playerEffect(name: SoundWin)
        
    }
    
    //@IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var audioController: AudioController
    required init?(coder aDecoder: NSCoder) {
        audioController = AudioController()
        audioController.preloadAudioEffects(audioFileNames: AudioEffectFiles)
        
        super.init(coder: aDecoder)
    }
    
    
    @IBAction func startTranscribing(_ sender: Any) {
        transcribeButton.isEnabled = false
        stopButton.isEnabled = true
        try! startSession()
        
    }
    
    
    func startSession() throws {
        
        if let recognitionTask = speechRecognitionTask {
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = speechRecognitionRequest else { fatalError("SFSpeechAudioBufferRecognitionRequest object creation failed") }
        
        let inputNode = audioEngine.inputNode
        
        recognitionRequest.shouldReportPartialResults = true
        
        speechRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            
            var finished = false
            
            if let result = result {
                self.titleText.text =
                    result.bestTranscription.formattedString
                finished = result.isFinal
            }
            
            if error != nil || finished {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
                
                self.transcribeButton.isEnabled = true
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            
            self.speechRecognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    @IBAction func stopTranscribing(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            speechRecognitionRequest?.endAudio()
            transcribeButton.isEnabled = true
            stopButton.isEnabled = false
        }
        switch (self.myTextView.text) {
            case "광진구" : self.pickerView.selectRow(0, inComponent: 0, animated: true)
                break
            case "구로구" : self.pickerView.selectRow(1, inComponent: 0, animated: true)
                break
            case "동대문구" : self.pickerView.selectRow(2, inComponent: 0, animated: true)
                break
            case "종로구" : self.pickerView.selectRow(3, inComponent: 0, animated: true)
                break
            default:
                break
            
    }
    
    }
    @IBAction func doneToPickerViewController(segue:UIStoryboardSegue)
        {
        }
    
    var pickerDataSource = ["제목 키워드 검색", "날짜 검색",  "장소 검색"]

    var search_utf8 = ""
    //보훈병원정보 OpenAPI 및 인증키
    //디폴트 시도코드 = 서울 (sideCd=110000)
    //ServiceKey = "sea100UMmw23Xycs33F1EQnumONR%2F9ElxBLzkilU9Yr1oT4TrCot8Y2p0jyuJP72x9rG9D8CN5yuEs6AS2sAiw%3D%3D"
    var url : String = "http:/api.gugak.go.kr/service/gugakPerformanceService/getPerformanceList?startDate=2015-01-01&endDate=2015-12-31&eventDate=2015-10-24&title=hi&place=hi&pageNo=1&numOfRows=10&ServiceKey=4VB0o7ZOlNdClfP%2FidH3cNjCCsAfg3APKmEf7Tqg4aS2uPSNn1pA2avCeTcqVVY4pV6I7252637lX8LFUtxXJQ%3D%3D"
    var sgguCd : String = "110023" //디폴트 시구코드 = 광진구
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        authorizeSR()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        search_utf8 = titleText.text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        if row == 0 {
            url = "http:/api.gugak.go.kr/service/gugakPerformanceService/getPerformanceList?startDate=2018-03-01&endDate=2018-12-31&title=\(search_utf8)&ServiceKey=4VB0o7ZOlNdClfP%2FidH3cNjCCsAfg3APKmEf7Tqg4aS2uPSNn1pA2avCeTcqVVY4pV6I7252637lX8LFUtxXJQ%3D%3D"
        } else if row == 1 {
            url = "http:/api.gugak.go.kr/service/gugakPerformanceService/getPerformanceList?startDate=2018-03-01&endDate=2018-12-31&eventDate=\(search_utf8)&ServiceKey=4VB0o7ZOlNdClfP%2FidH3cNjCCsAfg3APKmEf7Tqg4aS2uPSNn1pA2avCeTcqVVY4pV6I7252637lX8LFUtxXJQ%3D%3D"
        } else if row == 2 {
            url = "http:/api.gugak.go.kr/service/gugakPerformanceService/getPerformanceList?startDate=2018-03-01&endDate=2018-12-31&place=\(search_utf8)&ServiceKey=4VB0o7ZOlNdClfP%2FidH3cNjCCsAfg3APKmEf7Tqg4aS2uPSNn1pA2avCeTcqVVY4pV6I7252637lX8LFUtxXJQ%3D%3D"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segueToTableView" {
            if let navController = segue.destination as? UINavigationController {
                if let hospitalTableViewController = navController.topViewController as?
                    HospitalTableViewController {
                     hospitalTableViewController.url = url
                    /* hospitalTableViewController.url = "http:/api.gugak.go.kr/service/gugakPerformanceService/getPerformanceList?startDate=2018-01-01&endDate=2018-12-31&pageNo=1&numOfRows=10&ServiceKey=4VB0o7ZOlNdClfP%2FidH3cNjCCsAfg3APKmEf7Tqg4aS2uPSNn1pA2avCeTcqVVY4pV6I7252637lX8LFUtxXJQ%3D%3D" */
                }
            }
        }
    }
    
    func authorizeSR() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.transcribeButton.isEnabled = true
                    
                case .denied:
                    self.transcribeButton.isEnabled = false
                    
                case .restricted:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition restricted on device", for: .disabled)
                    
                case .notDetermined:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition not authorized", for: .disabled)
                }
            }
        }
    }

}

