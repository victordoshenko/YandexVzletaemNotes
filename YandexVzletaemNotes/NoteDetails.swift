//
//  NoteDetails.swift
//  Yandex49
//
//  Created by Victor Doshchenko on 20/07/2019.
//  Copyright © 2019 Victor Doshchenko. All rights reserved.
//

import UIKit

class NoteDetails: UIViewController, UITextViewDelegate {
  
    let notebook: FileNotebook
    var note: Note
    var delegate: testDelegateProtocol?

    let backendQueue = OperationQueue()
    let dbQueue = OperationQueue()
    let commonQueue = OperationQueue()

    init(notebook: FileNotebook, note: Note) {
        self.notebook = notebook
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        note.color = myTextView.textColor ?? UIColor.white
        
        //Операция сохранения заметки SaveNoteOperation, вызывается из UI по событию окончания редактирования
        let saveNoteOperation = SaveNoteOperation(
            note: note,
            notebook: notebook,
            backendQueue: backendQueue,
            dbQueue: dbQueue
        )
        
        let adapterOp = BlockOperation {
            self.delegate?.updateUI()
        }
        adapterOp.addDependency(saveNoteOperation)

        commonQueue.addOperation(saveNoteOperation)
        OperationQueue.main.addOperation(adapterOp)

    }
    
    @IBAction func dateChange(_ sender: UIDatePicker) {
        note.selfDestructionDate = datePicker.date
    }
    @IBAction func switchChanged(_ sender: UISwitch) {
        datePicker.isHidden = !sender.isOn
        note.selfDestructionDate = sender.isOn ? datePicker.date : nil
    }
    @IBAction func titleChange(_ sender: UITextField) {
        note.title = sender.text ?? ""
    }
    func textViewDidChange(_ textView: UITextView) {
        note.content = textView.text
    }

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var q1: UIImageView!
    @IBOutlet weak var q2: UIImageView!
    @IBOutlet weak var q3: UIImageView!
    @IBOutlet weak var q4: UIImageView!
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var noteView: UIScrollView!
    @IBOutlet weak var qc1: ColorPickerCursorView!
    @IBOutlet weak var qc2: ColorPickerCursorView!
    @IBOutlet weak var qc3: ColorPickerCursorView!
    @IBOutlet weak var qc4: ColorPickerCursorView!
    @IBOutlet weak var dateSwitch: UISwitch!
    
    @IBOutlet weak var colorPickerView: ColorPickerViewClass!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextView.delegate = self
        doShow()
    }

    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("taped1 !")
        qc1.isHidden = false
        qc2.isHidden = true
        qc3.isHidden = true
        qc4.isHidden = true
        myTextView.textColor = UIColor.white
        note.color = UIColor.white
    }
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("taped2 !")
        qc1.isHidden = true
        qc2.isHidden = false
        qc3.isHidden = true
        qc4.isHidden = true
        myTextView.textColor = UIColor.red
        note.color = UIColor.red
    }
    @objc func imageTapped3(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("taped3 !")
        qc1.isHidden = true
        qc2.isHidden = true
        qc3.isHidden = false
        qc4.isHidden = true
        myTextView.textColor = UIColor.green
        note.color = UIColor.green
    }
    @objc func imageTapped4(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("taped4 !")
        qc1.isHidden = true
        qc2.isHidden = true
        qc3.isHidden = true
        qc4.isHidden = false
        myTextView.textColor = colorPickerView.colorPickerView.ColorChoosen
        note.color = colorPickerView.colorPickerView.ColorChoosen
    }
    @objc func imageTapped4Long(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("taped4Long !")
        qc1.isHidden = true
        qc2.isHidden = true
        qc3.isHidden = true
        qc4.isHidden = false
        colorPickerView.isHidden = false
        colorPickerView.colorPickerView.ColorChoosen = myTextView.textColor ?? UIColor.white
        colorPickerView.colorPickerView.updateUI()
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        colorPickerView.colorPickerView.ColorChoosen.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        colorPickerView.mySlider.value = Float(brightness)
        noteView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOrHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOrHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        doShow()
    }
    
    private func doShow() {
        myTextView.translatesAutoresizingMaskIntoConstraints = false
        myTextView.sizeToFit()
        myTextView.isScrollEnabled = false
        
        q1.image = UIImage(named: "q1")
        q2.image = UIImage(named: "q2")
        q3.image = UIImage(named: "q3")
        q4.image = UIImage(named: "q4")
        
        qc1.backgroundColor = UIColor.clear
        qc2.backgroundColor = UIColor.clear
        qc3.backgroundColor = UIColor.clear
        qc4.backgroundColor = UIColor.clear
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1))
        q1.isUserInteractionEnabled = true
        q1.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2))
        q2.isUserInteractionEnabled = true
        q2.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3))
        q3.isUserInteractionEnabled = true
        q3.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(imageTapped4))
        q4.isUserInteractionEnabled = true
        q4.addGestureRecognizer(tapGestureRecognizer4)
        
        let tapGestureRecognizer5 = UILongPressGestureRecognizer(target: self, action: #selector(imageTapped4Long))
        q4.isUserInteractionEnabled = true
        q4.addGestureRecognizer(tapGestureRecognizer5)
        
        colorPickerView.noteView = noteView
        colorPickerView.textView = myTextView
        setupTextFields()
        
        noteTitle.text = note.title
        myTextView.text = note.content
        dateSwitch.isOn = note.selfDestructionDate != nil
        datePicker.date = note.selfDestructionDate ?? Date()
        datePicker.isHidden = note.selfDestructionDate == nil
        myTextView.textColor = note.color
        
        switch note.color {
        case UIColor.white:
            qc1.isHidden = false
            qc2.isHidden = true
            qc3.isHidden = true
            qc4.isHidden = true
        case UIColor.red:
            qc1.isHidden = true
            qc2.isHidden = false
            qc3.isHidden = true
            qc4.isHidden = true
        case UIColor.green:
            qc1.isHidden = true
            qc2.isHidden = true
            qc3.isHidden = false
            qc4.isHidden = true
        default:
            qc1.isHidden = true
            qc2.isHidden = true
            qc3.isHidden = true
            qc4.isHidden = false
        }
    }
    
    @objc private func keyboardWillShowOrHide(_ notification: Notification) {
        if let userInfo = notification.userInfo, let frameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            let bottomInset = notification.name == UIResponder.keyboardWillShowNotification ? frameEnd.height : 0
            
            noteView.contentInset.bottom = bottomInset
            noteView.scrollIndicatorInsets.bottom = bottomInset
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

extension NoteDetails {
    private func setupTextFields() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}
