//
//  MyAccountViewController.swift
//  Neostore
//
//  Created by Neosoft on 02/09/23.
//

import UIKit

class MyAccountViewController: UIViewController,UITextFieldDelegate {
    
    let viewModel = SideMenuViewmodel()
    //    var accessToken
    var accesstoken : String?
    var image: UIImage?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainbackView: UIView!
    @IBOutlet var myAccountTextViews: [UIView]!
    @IBOutlet weak var accountFname: UITextField!
    @IBOutlet weak var accountLname: UITextField!
    @IBOutlet weak var accountEmail: UITextField!
    @IBOutlet weak var accountPhoneNo: UITextField!
    @IBOutlet weak var accountDateOfBirth: UITextField!
    @IBOutlet weak var editbutton: UIButton!
    
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    var originalViewYPosition: CGFloat = 0.0
    let datePicker = UIPickerView()
    var selectedDate = ""
    let imagePicker = UIImagePickerController()
    
    //
    //pickerview data
    let days = Array(1...31)
    let months = Array(1...12)
    let minYear = 1970
    let maxYear = Calendar.current.component(.year, from: Date())
    lazy var years: [Int] = {
        return Array(minYear...maxYear)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountImage.image = UIImage(named: "saad")
        accountImage.layer.cornerRadius = accountImage.frame.size.width / 2
        accountImage.clipsToBounds = true
        
        for textViews in myAccountTextViews{
            textViews.layer.borderWidth = 1
            textViews.layer.borderColor = UIColor.white.cgColor
        }
        self.stopActivityIndicator()
        navigationController?.isNavigationBarHidden = false
        // for activating navigation bar
        
        // for removing back button title
        let backButton = UIBarButtonItem()
        backButton.title = "" // Set an empty title
        navigationItem.backBarButtonItem = backButton
        
        // navigation bar back image
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")
        
        // navigation bar back text
        navigationController?.navigationBar.backItem?.title = ""
        
        // navigation bar items color
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
        // setting title for navigation bar
        title = "AccountDetails"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Do any additional setup after loading the view.
        
        // deligate for picker view
        datePicker.delegate = self
        datePicker.dataSource = self
        
        accountDateOfBirth.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        accountDateOfBirth.inputAccessoryView = toolbar
        toolbar.tintColor = #colorLiteral(red: 0.05993984508, green: 0.04426076461, blue: 0.08429525985, alpha: 1)
        
        // setting th ecurrent data for pickedr view
        let currentDate = Date()
        let currentDay = Calendar.current.component(.day, from: currentDate)
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        let currentYear = Calendar.current.component(.year, from: currentDate)
        datePicker.selectRow(currentDay - 1, inComponent: 0, animated: false)
        datePicker.selectRow(currentMonth - 1, inComponent: 1, animated: false)
        if let yearIndex = years.firstIndex(of: currentYear) {
            datePicker.selectRow(yearIndex, inComponent: 2, animated: false)
        }
        accountDateOfBirth.text = "\(currentMonth)-\(currentDay)-\(currentYear)"
        
        
        // for pickerview
        NotificationCenter.default.addObserver(self, selector: #selector(pickerWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pickerWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        originalViewYPosition = view.frame.origin.y
        
        // for image editiong
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        accountImage.addGestureRecognizer(tapGesture)
        
        let viewtapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(viewtapGesture)
        accountDateOfBirth.inputView = datePicker
        //deligate
        accountFname.delegate = self
        accountLname.delegate = self
        accountEmail.delegate = self
        accountPhoneNo.delegate = self
        fillData()
        
    }
    
    @objc func handleImageTap() {
        view.endEditing(true)
        openActionSheetForUploadImage()
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountFname {
            accountLname.becomeFirstResponder() // Move to the next field (Last Name)
        } else if textField == accountLname {
            accountEmail.becomeFirstResponder() // Move to the next field (Email)
        } else if textField == accountEmail {
            accountPhoneNo.becomeFirstResponder() // Move to the next field (Phone Number)
        } else if textField == accountPhoneNo {
            accountDateOfBirth.becomeFirstResponder() // Move to the Date of Birth field
        } else {
            textField.resignFirstResponder() // Hide the keyboard for all other fields
        }
        
        return true
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc func pickerWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            // Check if the active text field is not FirstName or LastName
            if let activeTextField = UIResponder.currentFirstResponder as? UITextField,
               activeTextField != accountFname && activeTextField != accountLname {
                UIView.animate(withDuration: 0.3) {
                    // Move the view upward by the keyboard's height
                    UIView.animate(withDuration: 0.3) {
                        var contentInset:UIEdgeInsets = self.scrollView.contentInset
                        contentInset.bottom = keyboardFrame.size.height + 20
                        self.scrollView.contentInset = contentInset
                    }
                }
                
            }
        }
    }
    @objc func pickerWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            // Restore the view to its original position
            self.scrollView.contentInset = UIEdgeInsets.zero
        }
    }
    
    @objc func doneButtonTapped() {
        accountDateOfBirth.resignFirstResponder()
        if selectedDate.isEmpty{
            self.showAlert(msg: "selcet the proper date")
        }else{
            accountDateOfBirth.text = selectedDate
            print(selectedDate)
        }
    }
    @objc func cancelButtonTapped() {
        accountDateOfBirth.resignFirstResponder()
        
    }
    func assignDatatoTextfields(){
        
    }
    
    func fillData(){
        self.accountFname.text = SideMenuViewmodel.menuDemoData.data?.user_data?.first_name
        self.accountLname.text = SideMenuViewmodel.menuDemoData.data?.user_data?.last_name
        self.accountEmail.text = SideMenuViewmodel.menuDemoData.data?.user_data?.email
        self.accountPhoneNo.text = String(SideMenuViewmodel.menuDemoData.data?.user_data?.phone_no ?? "0")
        self.accountDateOfBirth.text = String(SideMenuViewmodel.menuDemoData.data?.user_data?.dob ?? "0")
        self.startActivityIndicator()
        DispatchQueue.global(qos: .background).async {
            if let accessToken = self.accesstoken,
               let imageData = UserDefaults.standard.data(forKey: accessToken),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.accountImage.image = image
                    self.stopActivityIndicator()
                }
            }else{
                DispatchQueue.main.async {
                  //  self.accountImage.image = UIImage(named: "userdefault")
                    self.stopActivityIndicator()
                }
            }
        }
        self.stopActivityIndicator()
    }
    
    
    
    
    
    @IBAction func EditProfileAction(_ sender: UIButton) {
        print("button is clicked")
        if sender.titleLabel?.text == "Edit Profile" {
            accountImage.isUserInteractionEnabled = true
            cancelButton.isHidden = false
            let attributedString = NSMutableAttributedString(string: "Save")
            title = "Save Details"
            let range = NSRange(location: 0, length: 4)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: range)
            sender.setAttributedTitle(attributedString, for: .normal)
            accountFname.isUserInteractionEnabled = true
            accountLname.isUserInteractionEnabled = true
            accountEmail.isUserInteractionEnabled = true
            accountPhoneNo.isUserInteractionEnabled = true
            accountDateOfBirth.isUserInteractionEnabled = true
            accountFname.becomeFirstResponder()
        }else{
            title = "AccountDetails"
            accountImage.isUserInteractionEnabled = false
            cancelButton.isHidden = true
            let attributedString = NSMutableAttributedString(string: "Edit Profile")
            let range = NSRange(location: 0, length: 12)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: range)
            sender.setAttributedTitle(attributedString, for: .normal)
            accountFname.isUserInteractionEnabled = false
            accountLname.isUserInteractionEnabled = false
            accountEmail.isUserInteractionEnabled = false
            accountPhoneNo.isUserInteractionEnabled = false
            accountDateOfBirth.isUserInteractionEnabled = false
            
            
            if let image = image  {
                if let imageData = image.pngData(), let accessToken = accesstoken {
                    // Save the image data in UserDefaults
                    UserDefaults.standard.set(imageData, forKey: accessToken)
                    accountImage.image = image
                }
            }
//            if let selectedImage = accountImage.image,let accessToken = accesstoken {
//                UserDefaults.standard.set(selectedImage, forKey: accessToken)
//            }
                
            viewModel.editAccountDetails(first_name: accountFname.text ?? "", last_name: accountLname.text ?? "", email: accountEmail.text  ?? "", dob: selectedDate , phone_no: accountPhoneNo.text ?? ""){
                responce in
                DispatchQueue.main.async {
                    if responce{
                        NotificationCenter.default.post(name: .reloadSideMenuData, object: nil)
                        print(self.accesstoken)
                        self.showAlert(msg: "Details Updated Succefully")
                    }else{
                        self.showAlert(msg: "Some Went Wrong")
                    }
                }
            }
        }
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        cancelButton.isHidden = true
        fillData()
        title = "AccountDetails"
        accountImage.isUserInteractionEnabled = false
        
        let attributedString = NSMutableAttributedString(string: "Edit Profile")
        let range = NSRange(location: 0, length: 12)
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: range)
        editbutton.setAttributedTitle(attributedString, for: .normal)
        accountFname.isUserInteractionEnabled = false
        accountLname.isUserInteractionEnabled = false
        accountEmail.isUserInteractionEnabled = false
        accountPhoneNo.isUserInteractionEnabled = false
        accountDateOfBirth.isUserInteractionEnabled = false
        
    }
    
    @IBAction func ResetPasswordAction(_ sender: UIButton) {
        navigationController?.pushViewController(ResetPassViewController(nibName:"ResetPassViewController", bundle: nil), animated: true)
    }
}

extension MyAccountViewController : UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3 // Three components: day, month, year
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return days.count
        case 1:
            return months.count
        case 2:
            return years.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(days[row])"
        case 1:
            return "\(months[row])"
        case 2:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Handle the selected date components
        let selectedDay = days[pickerView.selectedRow(inComponent: 0)]
        let selectedMonth = months[pickerView.selectedRow(inComponent: 1)]
        let selectedYear = years[pickerView.selectedRow(inComponent: 2)]
        
        // You can use these components to construct the selected date
        selectedDate = "\(selectedMonth)-\(selectedDay)-\(selectedYear)"
        //        print("Selected Date: \(selectedDate)")
    }
    
    
}

extension MyAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openActionSheetForUploadImage(){
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openGallary()
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
       // alert.addAction(removeImageAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
           
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img
            accountImage.image = image
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
            accountImage.image = image
        }

        // Convert the UIImage to Data

        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel Tapped")
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
