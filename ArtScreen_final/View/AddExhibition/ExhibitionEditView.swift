//
//  ExhibitionEditView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

protocol ExhibitionEditViewDelegate: class {
    func didTappedEditInfo_cancel()
}

class ExhibitionEditView: UIView {
    
    //MARK: - Properties
    weak var delegate: ExhibitionEditViewDelegate?
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addStackView_V()
        backgroundColor = .mainBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func tapBtnCancel() {
        print("btnCancel be tapped")
        self.delegate?.didTappedEditInfo_cancel()
    }
    
    @objc func tapBtnSend() {
        print("btnSend be tapped")
//        self.delegate?.didTappedSend()
    }
    
    @objc func tapBtnMerge() {
        print("btnMerge be tapped")
    }
    
    @objc func tapBtnDelete() {
        print("btnDelete be tapped")
    }
    
    //MARK: - Helpers
    func addStackView_V() {
        let stackView = UIStackView(frame: .zero)
        self.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
//        stackView.distribution = .equalCentering
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 30, left: 10, bottom: 70, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let view_Top = addView_Top()
        let view_Basic = addView_Basic()
        let view_Privacy = addView_Privacy()
        let view_Advanced = addView_Advanced()

        stackView.addArrangedSubview(view_Top)
        stackView.addArrangedSubview(view_Basic)
        stackView.addArrangedSubview(view_Privacy)
        stackView.addArrangedSubview(view_Advanced)
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        view_Basic.topAnchor.constraint(equalTo: view_Top.bottomAnchor, constant: 20).isActive = true
        view_Basic.heightAnchor.constraint(equalToConstant: 400).isActive = true
        view_Privacy.topAnchor.constraint(equalTo: view_Basic.bottomAnchor, constant: 50).isActive = true
        view_Advanced.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80).isActive = true
                
    }
    
    //MARK: - Add View Top
    func addView_Top() -> UIView{
        let view = UIView()
//        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setDimensions(width: 340, height: 50)
        
        ///Add a stcView into the view_Top
        let stcView_Top = addStcViewOfTop()
        view.addSubview(stcView_Top)
        stcView_Top.addArrangedSubview(addCancel())
        stcView_Top.addArrangedSubview(addTitle())
        stcView_Top.addArrangedSubview(addSend())
        
        setConstraintsToView(stackView: stcView_Top, toView: view)
        
        
        return view
    }
    func addStcViewOfTop() -> UIStackView{
        let stcView = UIStackView(frame: .zero)
        stcView.axis = .horizontal
        stcView.alignment = .center
        stcView.distribution = .fill
        stcView.spacing = 30
        stcView.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        stcView.isLayoutMarginsRelativeArrangement = true
        stcView.translatesAutoresizingMaskIntoConstraints = false
        return stcView
    }
    func addCancel() -> UIButton {
        let btnCancel = UIButton(type: .infoDark)
//        btnCancel.backgroundColor = .yellow
        btnCancel.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        btnCancel.tintColor = .mainPurple
        btnCancel.addTarget(self, action: #selector(tapBtnCancel), for: .touchUpInside)
        return btnCancel
    }
    func addTitle() -> UILabel {
        let label = UILabel()
        label.text = "Edit"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .mainPurple
        label.textAlignment = .center
//        label.backgroundColor = .brown
        return label
    }
    func addSend() -> UIButton {
        let btnPlus = UIButton(type: .infoDark)
//        btnPlus.backgroundColor = .yellow
        btnPlus.setImage(#imageLiteral(resourceName: "Send").withRenderingMode(.alwaysTemplate), for: .normal)
        btnPlus.tintColor = .mainPurple
        btnPlus.addTarget(self, action: #selector(tapBtnSend), for: .touchUpInside)
        return btnPlus
    }
    
    //MARK: - Add View Basic
    func addView_Basic() -> UIView{
        let view = UIView()
//        view.backgroundColor = .orange
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 340).isActive = true
        view.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        ///Add a stcView into the view_Basic
        let stcView_Basic = addStcViewOfBasic()
        view.addSubview(stcView_Basic)
        
        stcView_Basic.addArrangedSubview(addBasicLabel())
        stcView_Basic.addArrangedSubview(addExhibitionView())
        stcView_Basic.addArrangedSubview(addIntroductionLabel())
        stcView_Basic.addArrangedSubview(addIntroductionContent())
        stcView_Basic.addArrangedSubview(addTagLabel())
        stcView_Basic.addArrangedSubview(addTagContent())
        stcView_Basic.addArrangedSubview(addDivideLine())
        
        setConstraintsToView(stackView: stcView_Basic, toView: view)
        
        return view
    }
    func addStcViewOfBasic() -> UIStackView{
        let stcView = UIStackView(frame: .zero)
        stcView.axis = .vertical
        stcView.alignment = .fill
//        stcView.distribution = .equalSpacing
        stcView.distribution = .fill
        stcView.spacing = 5
        stcView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stcView.isLayoutMarginsRelativeArrangement = true
        stcView.translatesAutoresizingMaskIntoConstraints = false
        return stcView
    }
    func addBasicLabel() -> UILabel{
        let label = UILabel()
        label.text = "Basic"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .mainPurple
        label.textAlignment = .left
//        label.backgroundColor = .red
        label.setDimensions(width: 340, height: 40)
        return label
    }
    func addExhibitionView() -> UIView{
        let view = UIView()
//        view.backgroundColor = .blue
        
        ///Add a stcView into the view
        let stcView_Exbi = addStackViewOfExhibition()
        view.addSubview(stcView_Exbi)
        
        stcView_Exbi.addArrangedSubview(addExhibitionImg())
        stcView_Exbi.addArrangedSubview(addExhibitionContentView())
        
        setConstraintsToView(stackView: stcView_Exbi, toView: view)

        view.setDimensions(width: 340, height: 400)
//        view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        return view
    }
    /// Add a stackView to contain exhibition img and title
    func addStackViewOfExhibition() -> UIStackView{
        let stcView = UIStackView(frame: .zero)
        stcView.axis = .horizontal
        stcView.alignment = .top
        stcView.distribution = .fillEqually
        stcView.spacing = 10
        stcView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stcView.isLayoutMarginsRelativeArrangement = true
        stcView.translatesAutoresizingMaskIntoConstraints = false
        return stcView
    }
    func addExhibitionImg() -> UIImageView{
        let imgDefault = UIImage(named: "imgDefault")
        let imgView = UIImageView()
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        imgView.frame.size.width = 50
        imgView.frame.size.height = 50
        imgView.image = imgDefault
        imgView.backgroundColor = .mainPurple
        imgView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }
    /// Set a view to contain StackView
    func addExhibitionContentView() -> UIView{
        let view = UIView()
//        view.backgroundColor = .green
        view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        ///Add a stcView into the view
        let stcView_ExbiContent = addStackViewOfExhibitionContent()
        view.addSubview(stcView_ExbiContent)
        
        stcView_ExbiContent.addArrangedSubview(addExhibitionTitle())
        stcView_ExbiContent.addArrangedSubview(addExhibitionContent())
        
        setConstraintsToView(stackView: stcView_ExbiContent, toView: view)
        
        return view
    }
    func addStackViewOfExhibitionContent() -> UIStackView{
        let stcView = UIStackView(frame: .zero)
        stcView.axis = .vertical
        stcView.alignment = .fill
        stcView.distribution = .fill
        stcView.spacing = 5
        stcView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stcView.isLayoutMarginsRelativeArrangement = true
        stcView.translatesAutoresizingMaskIntoConstraints = false
        return stcView
    }
    func addExhibitionTitle() -> UILabel{
        let label = UILabel()
        label.text = "Exhibition Title"
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .mainPurple
        label.textAlignment = .left
//        label.backgroundColor = .red
        return label
    }
    func addExhibitionContent() ->UITextView{
        let textView = UITextView()
        textView.text = "Lorem ipsum dolor sit amet,consectetur adipiscing elit.Mauris fermentum nulla sit ametiaculis."
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .mainPurple
        textView.textAlignment = .left
        textView.keyboardType = .default
        textView.returnKeyType = .default
        textView.isEditable = true
        textView.isSelectable = true
//        textView.backgroundColor = .green
        textView.backgroundColor = UIColor(red: 241/255, green: 239/255, blue: 242/255, alpha: 1.0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        hideKeyboardWhenTappedAround()
        return textView
        

    }
    
    func addIntroductionLabel() -> UILabel{
        let label = UILabel()
        label.text = "Introduction"
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .mainPurple
        label.textAlignment = .left
//        label.backgroundColor = .white
        label.setDimensions(width: 340, height: 30)
        return label
    }
    func addIntroductionContent() ->UITextView{
        let textView = UITextView()
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris fermentum nulla sit amet elementum iaculis. Donec anisi dictum, hendrerit quam ut, consequat neque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptohimenaeos. Donec hendrerit facilisis tortor nec pretium."
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .mainPurple
        textView.textAlignment = .left
        textView.keyboardType = .default
        textView.returnKeyType = .default
        textView.isEditable = true
        textView.isSelectable = true
//        textView.backgroundColor = .green
        textView.backgroundColor = UIColor(red: 241/255, green: 239/255, blue: 242/255, alpha: 1.0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        hideKeyboardWhenTappedAround()
        return textView
    }
    func addTagLabel() -> UILabel{
        let label = UILabel()
        label.text = "#Tag"
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .mainPurple
        label.textAlignment = .left
//        label.backgroundColor = .white
        label.setDimensions(width: 340, height: 30)
        return label
    }
    func addTagContent() -> UITextView{
        let textView = UITextView()
        textView.text = "#tag contents"
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .mainPurple
        textView.textAlignment = .left
        textView.keyboardType = .default
        textView.returnKeyType = .default
        textView.isEditable = true
        textView.isSelectable = true
//        textView.backgroundColor = .green
        textView.backgroundColor = UIColor(red: 241/255, green: 239/255, blue: 242/255, alpha: 1.0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        hideKeyboardWhenTappedAround()
        return textView
    }
    func addDivideLine() ->UIImageView{
        let imgDefault = UIImage(named: "line_purple")
        let imgView = UIImageView()
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        imgView.image = imgDefault
        imgView.widthAnchor.constraint(equalToConstant: 375).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return imgView
    }
    
    //MARK: - Add View Privacy
    func addView_Privacy() -> UIView{
        let view = UIView()
//        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 340).isActive = true
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        /// Add stackView to  view
        let stcView_Privacy = addStcViewOfBasic()
        view.addSubview(stcView_Privacy)
        
        stcView_Privacy.addArrangedSubview(addPrivacyLabel())
        stcView_Privacy.addArrangedSubview(addOnlineView())
        stcView_Privacy.addArrangedSubview(addOpenTicketView())
        stcView_Privacy.addArrangedSubview(addDivideLine())
        
        setConstraintsToView(stackView: stcView_Privacy, toView: view)
        
        return view
    }
    func addStcViewOfPrivacy() -> UIStackView{
        let stcView = UIStackView(frame: .zero)
        stcView.axis = .vertical
        stcView.alignment = .fill
        stcView.distribution = .fill
        stcView.spacing = 10
        stcView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stcView.isLayoutMarginsRelativeArrangement = true
        stcView.translatesAutoresizingMaskIntoConstraints = false
        return stcView
    }
    func addPrivacyLabel() -> UILabel{
        let label = UILabel()
        label.text = "Privacy"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .mainPurple
        label.textAlignment = .left
//        label.backgroundColor = .white
        return label
    }
    /// View that contains stackView to show " Online Exhibtion " & switchButton
    func addOnlineView() -> UIView{
        let view = UIView()
//        view.backgroundColor = .green
        view.widthAnchor.constraint(equalToConstant: 340).isActive = true
        let stcView_Online = addStcViewOfOnline()
        view.addSubview(stcView_Online)
        stcView_Online.addArrangedSubview(addOnlineLabel())
        stcView_Online.addArrangedSubview(addOnlineSwitch())
        setConstraintsToView(stackView: stcView_Online, toView: view)
        
        return view
    }
    func addStcViewOfOnline() -> UIStackView{
        let stcView = UIStackView(frame: .zero)
        stcView.axis = .horizontal
        stcView.alignment = .center
        stcView.distribution = .fill
        stcView.spacing = 10
        stcView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stcView.isLayoutMarginsRelativeArrangement = true
        stcView.translatesAutoresizingMaskIntoConstraints = false
        return stcView
    }
    func addOnlineLabel() -> UILabel{
        let label = UILabel()
        label.text = "Online Exhibition"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .mainPurple
        label.textAlignment = .left
        return label
    }
    func addOnlineSwitch() -> UISwitch{
        let onlineSwitch = UISwitch()
        onlineSwitch.isOn = true
        return onlineSwitch
    }
    /// View that contains stackView to show " Open Ticket " & switchButton
    func addOpenTicketView() -> UIView{
        let view = UIView()
//        view.backgroundColor = .green
        view.widthAnchor.constraint(equalToConstant: 340).isActive = true
        let stcView_Ticket = addStcViewOfOnline()
        view.addSubview(stcView_Ticket)
        stcView_Ticket.addArrangedSubview(addTicketLabel())
        stcView_Ticket.addArrangedSubview(addTicketSwitch())
        setConstraintsToView(stackView: stcView_Ticket, toView: view)
        return view
    }
    func addStcViewOfTicket() -> UIStackView{
        let stcView = UIStackView(frame: .zero)
        stcView.axis = .horizontal
        stcView.alignment = .fill
        stcView.distribution = .fill
        stcView.spacing = 10
        stcView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stcView.isLayoutMarginsRelativeArrangement = true
        stcView.translatesAutoresizingMaskIntoConstraints = false
        return stcView
    }
    func addTicketLabel() -> UILabel{
        let label = UILabel()
        label.text = "Open ticket"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .mainPurple
        label.textAlignment = .left
        return label
    }
    func addTicketSwitch() -> UISwitch{
        let ticketSwitch = UISwitch()
        ticketSwitch.isOn = true
        return ticketSwitch
    }
    
    //MARK: - Add View Advanced
    func addView_Advanced() -> UIView{
        let view = UIView()
//        view.backgroundColor = .green
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 340).isActive = true
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        let stcView_Advanced = addStcViewOfAdvanced()
        view.addSubview(stcView_Advanced)
        stcView_Advanced.addArrangedSubview(addAdvancedLabel())
        stcView_Advanced.addArrangedSubview(addMergeBtn())
        stcView_Advanced.addArrangedSubview(addDeleteBtn())
        setConstraintsToView(stackView: stcView_Advanced, toView: view)
        return view
    }
    func addStcViewOfAdvanced() -> UIStackView{
        let stcView = UIStackView(frame: .zero)
        stcView.axis = .vertical
        stcView.alignment = .fill
        stcView.distribution = .fill
        stcView.spacing = 10
        stcView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stcView.isLayoutMarginsRelativeArrangement = true
        stcView.translatesAutoresizingMaskIntoConstraints = false
        return stcView
    }
    func addAdvancedLabel() -> UILabel{
        let label = UILabel()
        label.text = "Advanced"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .mainPurple
        label.textAlignment = .left
        return label
    }
    func addMergeBtn() -> UIButton{
        let button = UIButton()
        button.setTitle("Merge other Exhibition", for: .normal)
        button.setTitleColor(.mainPurple, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(tapBtnMerge), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return button
    }
    func addDeleteBtn() -> UIButton{
        let button = UIButton()
        button.setTitle("Delete Exhibition", for: .normal)
        button.setTitleColor(.mainPurple, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(tapBtnDelete), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return button
    }
    
    //MARK: - Constraints Settings
    func setConstraintsToView(stackView: UIStackView, toView: UIView) {
        stackView.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
    }
}


//MARK: - Close Keyboard
extension ExhibitionEditView {
    /// tap outside the textField to close the keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddExhibitionController.hideKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    @objc func hideKeyboard() {
        endEditing(true)
    }
}
//MARK: - textField Delegate
extension ExhibitionEditView: UITextFieldDelegate {
    /// tap "done" button after finished typing to close the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
}
