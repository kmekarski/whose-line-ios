//
//  MainMenuView.swift
//  WhoseLine
//
//  Created by Klaudiusz Mękarski on 13/02/2024.
//

import SwiftUI

struct MainMenuView: View {
    @State private var navPath: [String] = []
    @State var showSettings: Bool = false
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            ScrollView {
                VStack {
                    header
                        .padding(.bottom, 8)
                    menuButtons
                }
                .padding(.top)
                .padding(.horizontal)
            }
            SettingsModalView(isShowing: $showSettings)
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MainMenuView()
                .environmentObject(dev.playersVM)
        }
    }
}

extension MainMenuView {
    private var header: some View {
        HStack(alignment: .top) {
            IconButtonView("gearshape.fill").opacity(0)
            Spacer()
            Image("MainLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 156)
            Spacer()
            Button {
                showSettings.toggle()
            } label: {
                IconButtonView("gearshape.fill")
                    .offset(y: 18)
            }
        }
    }
    
    private var menuButtons: some View {
        VStack {
            ForEach(GameMode.allCases, id: \.self) { mode in
                NavigationLink(value: AppState.gameSettings.rawValue + mode.rawValue) {
                    MainMenuOptionView(title: mode.title, subtitle: mode.subtitle, icon: mode.icon, foregroundColor: .white, backgroundColor: .theme.accent)
                }
                .padding(.bottom, 10)
            }
        }
    }
}
