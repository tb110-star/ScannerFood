//
//  TabView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//


import SwiftUI


struct TabView: View {
    let bgColor: Color = .init(white: 0.9)
    @EnvironmentObject var settingVM: SettingVM
    @EnvironmentObject var tabVM: TabVM
     //var viewModel : ScanViewModel
    var body: some View {
        ZStack{
            Color.timberwolf.ignoresSafeArea(.all)

            TabContentView()
                .padding(.bottom,50)
            VStack{
                Spacer()
                TabsLayoutView()
                    .padding()
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.5))
                            .background(.ultraThinMaterial)
                            .blur(radius: 8)
                    )
                    .frame(height: 70)
                    .shadow(radius: 30)
                   .padding(.bottom, -2)
                    .padding()

            }
            .ignoresSafeArea(edges: .bottom)
        }
        
         }
}
struct TabContentView : View {
    @EnvironmentObject var tabVM: TabVM
    
    var body: some View{
        switch tabVM.selectedTab {
        case .home:
            HomeView()
        case .scann:
           ScanView(viewModel: ScanViewModel(isMock: true))

        case .favorite:
            FavoriteView()
//        case .setting:
//            SettingView()
            
        }
    }
}
fileprivate struct TabsLayoutView: View {
    @EnvironmentObject var tabVM: TabVM
    @Namespace var namespace
    var body: some View {
        HStack {
            ForEach(Tab.allCases) { tab in
                TabButton(tab: tab, namespace: namespace)
            }
        }
    }
}
 struct TabButton: View {
    let tab: Tab
    @EnvironmentObject var tabVM: TabVM
    var namespace: Namespace.ID
    @State private var selectedOffset: CGFloat = 0
    @State private var rotationAngle: CGFloat = 0
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                tabVM.selectedTab = tab
            }
            
            selectedOffset = -60
            if tab < tabVM.selectedTab {
                rotationAngle += 360
            } else {
                rotationAngle -= 360
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                selectedOffset = 0
                if tab < tabVM.selectedTab {
                    rotationAngle += 720
                } else {
                    rotationAngle -= 720
                }
            }
        } label: {
            ZStack {
                if isSelected {
                    Capsule()
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                }
                HStack(spacing: 10) {
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(isSelected ? tab.color : .black.opacity(0.6))
                        .rotationEffect(.degrees(rotationAngle))
                        .scaleEffect(isSelected ? 1 : 0.9)
                        .animation(.easeInOut, value: rotationAngle)
                        .opacity(isSelected ? 1 : 0.7)
                        .padding(.leading, isSelected ? 20 : 0)
                        .padding(.horizontal, tabVM.selectedTab != tab ? 10 : 0)
                        .offset(y: selectedOffset)
                        .animation(.default, value: selectedOffset)
                    
                    if isSelected {
                        Text(tab.title)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(tab.color)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.vertical, 10)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var isSelected: Bool {
        tabVM.selectedTab == tab
    }
}

#Preview {
    let settingVM = SettingVM()
    let tabVM = TabVM()
    
    //TabView(viewModel: ScanViewModel(isMock: true))
    TabView()
        .environmentObject(settingVM)
        .environmentObject(tabVM)
    
}
