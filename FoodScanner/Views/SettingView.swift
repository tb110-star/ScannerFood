
import SwiftUI

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme
    @Bindable var settingVM: SettingVM
    @Bindable var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.timberwolf.ignoresSafeArea(.all)
                   // .background(.regularMaterial)
                  //  .backgroundStyle(.tint)


            
//                ScrollView {
//                    VStack(alignment:.leading) {
//                        Section {
//                            Toggle(isOn: $settingVM.isDarkMode) {
//                                Text(settingVM.isDarkMode ? "Dark Mode" : "Light Mode")
//                            }
//                            .toggleStyle(SwitchToggleStyle(tint: .green))
//                            
//                            Picker("Font Size", selection: $settingVM.selectedFontSize) {
//                                ForEach(FontSizeOption.allCases, id: \.self) { size in
//                                    Text(size.rawValue).tag(size)
//                                }
//                            }
//                            .pickerStyle(SegmentedPickerStyle())
//                        } header: {
//                            Label("Personal Settings", systemImage: "person.fill")
//                        }
//                    }
//                    VStack(alignment:.leading) {
//                    Section {
//                        Link(destination: URL(string: "https://www.google.com")!) {
//                            Label("Help Forum", systemImage: "globe")
//                        }
//                        
//                        Link(destination: URL(string: "tel://+4912345")!) {
//                            Label("Hotline", systemImage: "phone")
//                        }
//                    } header: {
//                        Label("Help", systemImage: "questionmark.circle.fill")
//                    }
//                }
//                    }
                ScrollView {
                    VStack(alignment:.leading) {
                        Section(
                            header: Label("Personal Settings", systemImage: "person.fill").scaleEffect(0.9)
                                .foregroundColor(colorScheme == .dark ? .white : .gray))
                        {
                            VStack{
                                Toggle(isOn: $settingVM.isDarkMode) {
                                    Text(settingVM.isDarkMode ? "Dark Mode" : "Light Mode")
                                }
                                Divider()
                                VStack(alignment:.leading ){
                                    Text("Select Font size")
                                    Spacer()
                                    Picker("Font Size", selection: $settingVM.selectedFontSize) {
                                        ForEach(FontSizeOption.allCases, id: \.self) { size in
                                            Text(size.rawValue).tag(size)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(12)
                            
                        }
                        Divider()
                        
                        Section(
                            header: Label("Help", systemImage: "questionmark.circle.fill").scaleEffect(0.9)
                                .foregroundColor(colorScheme == .dark ? .white : .gray))
                        {
                            VStack(alignment:.leading){
                                Link(destination: URL(string: "https://www.google.com")!) {
                                    HStack{
                                        Image(systemName: "globe")
                                        Text("Help Forum")
                                    }
                                }
                                Divider()
                                Link(destination: URL(string: "tel://+4912345")!) {
                                    HStack{
                                        Image(systemName: "phone")
                                        Text("Hotline")
                                    }
                                }
                            }
                            .foregroundColor(colorScheme == .dark ? .white : .darkGreen)
                            .padding()
                            .frame(maxWidth: .infinity,maxHeight:.infinity)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(12)
                            
                        }
                        Section (
                            header: Label("Account", systemImage: "").scaleEffect(0.9)
                                .foregroundColor(colorScheme == .dark ? .white : .gray))
                        {
                            VStack(alignment:.leading){
                                if authViewModel.isUserSignedIn {
                                    Button(action: {
                                        authViewModel.signOut()
                                    }) {
                                        Label("Sign Out", systemImage: "arrow.right.circle.fill")
                                            .foregroundColor(.indigo)
                                    }
                                } else {
                                    Button(action: {
                                        authViewModel.signIn()
                                    }) {
                                        Label("Sign In", systemImage: "person.crop.circle.fill")
                                    }
                                }
                                
                            }
                            
                            .foregroundColor(colorScheme == .dark ? .white : .darkGreen)
                            .padding()
                            .frame(maxWidth: .infinity,maxHeight:.infinity)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(12)
                        }
                    }
                .padding()

                        }
                    .padding()
                
            }
            .navigationTitle("Setting")
            .toolbarBackground(.ultraThinMaterial.opacity(0.5), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)

            .preferredColorScheme(settingVM.isDarkMode ? .dark : .light)
            .font(.system(size: settingVM.selectedFontSize.size))
            .foregroundColor(colorScheme == .dark ? .timberwolf : .fontDarkGreen)
            .toolbarColorScheme(colorScheme == .dark ?.dark : .light, for: .navigationBar)
        }

    }
}

#Preview {
    let settingVM = SettingVM()
    SettingView(settingVM: settingVM, authViewModel: AuthViewModel())
}

/*
 import SwiftUI

 struct SettingView: View {
     @EnvironmentObject var settingVM: SettingVM
     @Environment(\.colorScheme) var colorScheme
     var body: some View {

        NavigationStack {
         ZStack {
             Color.timberwolf.ignoresSafeArea(.all)
         ScrollView {
         VStack(alignment:.leading) {
             Section(
                 header: Label("Personal Settings", systemImage: "person.fill").scaleEffect(0.9)
                     .foregroundColor(colorScheme == .dark ? .white : .gray))
                  {
                             VStack{
                                 Toggle(isOn: $settingVM.isDarkMode) {
                                     Text(settingVM.isDarkMode ? "Dark Mode" : "Light Mode")
                                 }
                                 Divider()
                                 VStack(alignment:.leading ){
                                     Text("Select Font size")
                                     Spacer()
                                     Picker("Font Size", selection: $settingVM.selectedFontSize) {
                                         ForEach(FontSizeOption.allCases, id: \.self) { size in
                                             Text(size.rawValue).tag(size)
                                         }
                                     }
                                 }
                             }
                             .toggleStyle(SwitchToggleStyle(tint: .green))
                             .padding()
                             .background(Color.white.opacity(0.3))
                             .cornerRadius(12)

                         }
             Divider()

             Section(
                 header: Label("Help", systemImage: "questionmark.circle.fill").scaleEffect(0.9)
                     .foregroundColor(colorScheme == .dark ? .white : .gray))
             {
                 VStack(alignment:.leading){
                                 Link(destination: URL(string: "https://www.google.com")!) {
                                     HStack{
                                         Image(systemName: "globe")
                                         Text("Help Forum")
                                     }
                                 }
                                 Divider()
                                 Link(destination: URL(string: "tel://+4912345")!) {
                                     HStack{
                                         Image(systemName: "phone")
                                         Text("Hotline")
                                     }
                                }
                             }
             .foregroundColor(colorScheme == .dark ? .white : .darkGreen)
                             .padding()
                             .frame(maxWidth: .infinity,maxHeight:.infinity)
                             .background(Color.white.opacity(0.3))
                             .cornerRadius(12)

                         }
                     }
         .padding()

                 }


                 .padding()

                 .pickerStyle(SegmentedPickerStyle())

                 .navigationTitle("Setting")

 //                .onAppear {
 //                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = settingVM.isDarkMode ? .dark : .light
 //                }

                 .preferredColorScheme(settingVM.isDarkMode ? .dark : .light)
             }
              .foregroundColor(colorScheme == .dark ? .timberwolf : .fontDarkGreen)

             .font(.system(size: settingVM.selectedFontSize.size))
         }
     }
 }

 #Preview {
     let settingVM = SettingVM()
     SettingView()
         .environmentObject(settingVM)
 }
 */
