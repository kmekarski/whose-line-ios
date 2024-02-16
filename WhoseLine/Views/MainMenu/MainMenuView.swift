//
//  MainMenuView.swift
//  WhoseLine
//
//  Created by Klaudiusz Mękarski on 13/02/2024.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStack {
                ScrollView {
                    header
                        .padding(.bottom, 8)
                    menuButtons
                }
            }
            .padding(.top)
        .padding(.horizontal, 24)
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .environmentObject(dev.homeVM)
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
//                .background(Color.blue)
            Spacer()
            Button {
            } label: {
                IconButtonView("gearshape.fill")
                    .offset(y: 18)
            }
        }
    }
    
    private var menuButtons: some View {
        VStack(spacing: 16) {
            ForEach(1..<6) {_ in
                Button {
                    homeVM.startGame()
                } label: {
                    MainMenuOptionView(title: "Scenes from a Hat", subtitle: "Classic WLIIA Game", icon: "gear", foregroundColor: .white, backgroundColor: .theme.accent)                }
            }
        }
    }
}