//
//  CreateRecord.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/8.
//

import SwiftUI
import PhotosUI
import CoreData

struct DateTimeView: View {
    var body: some View {
        VStack {
            Text(currentDateTime())
                .font(.system(size: 14))
                .foregroundColor(.black)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color(red: 247/255, green: 251/255, blue: 246/255))
                .cornerRadius(5)
        }
    }
}

func currentDateTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd HH:mm"
    return dateFormatter.string(from: Date())
}

struct CreatePageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coreDataStack: CoreDataStack
    @State private var isSheetPresented = false
    @State private var titleText = ""
    @State private var descriptionText = ""
    @State private var selectedMood: String?
    @State private var selectedImages: [UIImage] = []
    @State private var isImagePickerPresented: Bool = false
    @State private var showAlert = false
    @State private var errorMessage: String?
    @State private var showNavigationBar = false
    @State private var isKeyboardVisible: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    var title: String
    
    private var isDisabled: Bool {
        if titleText.isEmpty || descriptionText.isEmpty {
            return true
        }

        if selectedMood == nil && title == "心情" {
            return true
        }

        return false
    }
    
    private func showSaveAlert() {
        if isDisabled {
            if titleText.isEmpty {
                self.errorMessage = "你忘记标题咯"
            } else if descriptionText.isEmpty {
                self.errorMessage = "要不要描述一下细节呢"
            } else if selectedMood == nil {
                self.errorMessage = "今天的心情是啥样的呢"
            }
            self.showAlert = true
        } else {
            self.presentationMode.wrappedValue.dismiss()
            showNavigationBar = true
            let preMoodRecordCount = UserDefaults.standard.integer(forKey: "moodRecordCount")
            UserDataManager.shared.updatemoodRecordCount(moodRecordCount: preMoodRecordCount+1)
            UserDataManager.shared.updateCheckInStatus()
            if title == "心情" {
                coreDataStack.saveUserMood(title: titleText, descriptionText: descriptionText, mood: selectedMood ?? "暂无", selectedImages: selectedImages)
                UserDataManager.shared.updatetodayMood(todayMood: selectedMood ?? "暂无")
                UserDataManager.shared.updateEmotionCounts(selectedMood: selectedMood)
            }else {
                coreDataStack.saveUserNote(title: titleText, descriptionText: descriptionText, selectedImages: selectedImages)
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 169/255, green: 196/255, blue: 148/255), .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    VStack {
                        HStack{
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                                showNavigationBar = true
                            }) {
                                Image(systemName: "arrowshape.left.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("F7FBF6")) // 设置箭头颜色
                                    .padding(.leading)
                                
                                Text(title)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("F7FBF6"))
                                    .padding(.trailing, 20)
                            }

                            Spacer()
                            
                            DateTimeView()
                        }
                            .padding(.horizontal)
                        
                        VStack{
                            VStack {
                                // 输入区域 - 标题
                                ScrollView(.horizontal, showsIndicators: false) {
                                    TextField("标题", text: $titleText)
                                        .font(.system(size: 22, weight: .bold))
                                        .padding(.horizontal, 10)
                                        .foregroundColor(Color.black)
                                        .frame(width: UIScreen.main.bounds.width * 0.8)
                                        .onTapGesture {
                                            // 点击输入框时显示键盘
                                            isKeyboardVisible = true
                                        }
                                        .padding(.top,isKeyboardVisible ? keyboardHeight / 2 : 0)
                                }
                                
                                Divider().frame(height: 1).background(Color("7B8B6F"))

                                // 输入区域 - 记录
                                ScrollView {
                                    TextEditor(text: $descriptionText)
                                        .font(.system(size: 18))
                                        .foregroundColor(Color.black)
                                        .frame(width: UIScreen.main.bounds.width * 0.8, height:UIScreen.main.bounds.height * 0.5)
                                        .background(Color.white)
                                        .scrollContentBackground(.hidden)
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(10)
                                        .onTapGesture {
                                            // 点击输入框时显示键盘
                                            isKeyboardVisible = true
                                        }
                                }
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(selectedImages, id: \.self) { image in
                                            UploadedImageView(image: image) {
                                                if let index = selectedImages.firstIndex(of: image) {
                                                    selectedImages.remove(at: index)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal,10)
                                .padding(.vertical,10)

                                // 按钮区域
                                HStack(spacing: 15) {
                                    if title == "心情" {
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: UIScreen.main.bounds.width * 0.6, height: 40)
                                            .foregroundColor(Color(hex: "849B80"))
                                            .overlay(
                                                HStack(spacing: 5) {
                                                    ChooseMoodView(selectedMood: $selectedMood)
                                                    
                                                    Spacer()
                                                    Button(action: {
                                                        isImagePickerPresented.toggle()
                                                    }) {
                                                        Image(systemName: "photo.fill.on.rectangle.fill")
                                                            .foregroundColor(Color("414F3F"))
                                                    }
                                                    .sheet(isPresented: $isImagePickerPresented) {
                                                        PhotoPicker(selectedImages: $selectedImages)
                                                    }
                                                    .padding(.trailing, 5)
                                                }
                                                .padding(.horizontal, 10)
                                            )
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: UIScreen.main.bounds.width * 0.18, height: 40)
                                            .foregroundColor(Color(hex: "849B80"))
                                            .overlay(
                                                Button("保存") {
                                                    // 处理保存按钮点击事件
                                                    showSaveAlert()
                                                }
                                                .font(.system(size: 14))
                                                .foregroundColor(.white)
                                            )
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: 40)
                                            .foregroundColor(Color(hex: "849B80"))
                                            .overlay(
                                                Button(action: {
                                                    isImagePickerPresented.toggle()
                                                }) {
                                                    Image(systemName: "photo.fill.on.rectangle.fill")
                                                        .foregroundColor(Color("414F3F"))
                                                }
                                                .sheet(isPresented: $isImagePickerPresented) {
                                                    PhotoPicker(selectedImages: $selectedImages)
                                                }
                                                .padding(.trailing, 5)
                                            )
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: UIScreen.main.bounds.width * 0.68, height: 40)
                                            .foregroundColor(Color(hex: "849B80"))
                                            .overlay(
                                                Button("保存") {
                                                    // 处理保存按钮点击事件
                                                    showSaveAlert()
                                                }
                                                .font(.system(size: 14))
                                                .foregroundColor(.white)
                                            )
                                    }
                                }

                            }
                            .padding(20)
                            .cornerRadius(10)
                            .background(Color.white.cornerRadius(10))
                        }
                        .padding(.horizontal)
                        .frame(height: UIScreen.main.bounds.height * 0.85)
                    }
                }
            }
        }
        .gesture(
            // 添加一个点击手势来隐藏键盘
            TapGesture()
                .onEnded { _ in
                    hideKeyboard()
                }
        )
        .onAppear {
            // 监听键盘的可见性变化
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardHeight = keyboardFrame.height
                    isKeyboardVisible = true
                }
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                isKeyboardVisible = false
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("🔔"), message: Text(errorMessage ?? "可不能什么都不填哦").font(.system(size: 16)), dismissButton: .default(Text("知道啦")))
        }
        .toolbar(showNavigationBar ? .visible : .hidden, for: .tabBar)
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                        if let image = object as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(image)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct UploadedImageView: View {
    let image: UIImage
    let onDelete: () -> Void

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Button(action: {
                onDelete()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
            }
        }
    }
}

struct CreatePageView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePageView(title: "心情")
    }
}
