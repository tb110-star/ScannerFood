
import SwiftUI

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme
    @Bindable var settingVM: SettingVM
    var body: some View {
        NavigationStack {
            ZStack {
                Color.timberwolf.ignoresSafeArea(.all)

            
                    Form {
                        Section {
                            Toggle(isOn: $settingVM.isDarkMode) {
                                Text(settingVM.isDarkMode ? "Dark Mode" : "Light Mode")
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .green))

                            Picker("Font Size", selection: $settingVM.selectedFontSize) {
                                ForEach(FontSizeOption.allCases, id: \.self) { size in
                                    Text(size.rawValue).tag(size)
                                }
                            }
                            .pickerStyle(.inline)
                        } header: {
                            Label("Personal Settings", systemImage: "person.fill")
                        }

                        Section {
                            Link(destination: URL(string: "https://www.google.com")!) {
                                Label("Help Forum", systemImage: "globe")
                            }

                            Link(destination: URL(string: "tel://+4912345")!) {
                                Label("Hotline", systemImage: "phone")
                            }
                        } header: {
                            Label("Help", systemImage: "questionmark.circle.fill")
                        }
                    }
                    .padding()
                
            }
            .navigationTitle("Setting")
            .preferredColorScheme(settingVM.isDarkMode ? .dark : .light)
            .font(.system(size: settingVM.selectedFontSize.size))
            .foregroundColor(colorScheme == .dark ? .timberwolf : .fontDarkGreen)
        }
    }
}

#Preview {
    let settingVM = SettingVM()
    SettingView(settingVM: settingVM)
}

