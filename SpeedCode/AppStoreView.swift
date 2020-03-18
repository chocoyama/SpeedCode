//
//  AppStoreView.swift
//  SpeedCode
//
//  Created by Takuya Yokoyama on 2020/03/19.
//  Copyright © 2020 Takuya Yokoyama. All rights reserved.
//

import SwiftUI

private let itemHeight: CGFloat = 350

enum TransitionStatus: Equatable {
    case transitioning(sourceRect: CGRect)
    case presented
}

struct AppStoreView: View {
    @State var isPresenting = false
    @State var transitionStatus: TransitionStatus?
    @State var sourceRect: CGRect?
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("3月18日 水曜日")
                        .padding(.top, 16)
                    HStack {
                        Text("Today")
                            .font(.largeTitle)
                        Spacer()
                        Image(systemName: "person")
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                    
                    ForEach(0..<5) { _ in
                        GeometryReader { proxy in
                            ItemView()
                                .cornerRadius(16)
                                .padding([.top, .bottom], 8)
                                .onTapGesture {
                                    withAnimation {
                                        self.transitionStatus = .transitioning(sourceRect: proxy.frame(in: .global))
                                        self.isPresenting = true
                                        self.sourceRect = proxy.frame(in: .global)
                                    }
                                }
                        }.frame(height: itemHeight)
                    }
                }
            }.padding([.leading, .trailing], 32)
            
            if isPresenting {
                DetailView(transitionStatus: self.transitionStatus!) {
                    withAnimation {
                        self.isPresenting = false
                    }
                }
                .animation(.spring())
                .onTapGesture {
                    withAnimation {
                        self.transitionStatus = .transitioning(sourceRect: self.sourceRect!)
                    }
                }
                .onAppear {
                    withAnimation {
                        self.transitionStatus = .presented
                    }
                }
            }
        }
    }
}

struct DetailView: View {
    let transitionStatus: TransitionStatus
    let didAnimated: () -> Void
    
    private let contents = """
fkdlsa;fjdlskfj;alsdkfja;sldkfja;sldkfjas;dlkfjals;dkfjals;dsldkfjas;dlkfjals;dkfjals;d
fkdlsa;fjdlskfj;alsdkfja;sldkfja;sldkfjas;dlkfjals;dkfjals;dsldkfjas;dlkfjals;dkfjals;d

fkdlsa;fjdlskfj;alsdkfja;sldkfja;sldkfjas;dlkfjals;dkfjals;dsldkfjas;dlkfjals;dkfjals;d
fkdlsa;fjdlskfj;alsdkfja;sldkfja;sldkfjas;dlkfjals;dkfjals;dsldkfjas;dlkfjals;dkfjals;d

fkdlsa;fjdlskfj;alsdkfja;sldkfja;sldkfjas;dlkfjals;dkfjals;dsldkfjas;dlkfjals;dkfjals;d
fkdlsa;fjdlskfj;alsdkfja;sldkfja;sldkfjas;dlkfjals;dkfjals;dsldkfjas;dlkfjals;dkfjals;d

fkdlsa;fjdlskfj;alsdkfja;sldkfja;sldkfjas;dlkfjals;dkfjals;dsldkfjas;dlkfjals;dkfjals;d
fkdlsa;fjdlskfj;alsdkfja;sldkfja;sldkfjas;dlkfjals;dkfjals;dsldkfjas;dlkfjals;dkfjals;d

fkdlsa;fjdlskfj;alsdkfja;sldkfja;sldkfjas;dlkfjals;dkfjals;dsldkfjas;dlkfjals;dkfjals;d
fkdlsa;fjdlskfj;alsdkfja;sldkfja;sldkfjas;dlkfjals;dkfjals;dsldkfjas;dlkfjals;dkfjals;d
"""
    
    private var size: CGSize? {
        switch transitionStatus {
        case .transitioning(let sourceRect):
            return .init(width: sourceRect.width, height: sourceRect.height)
        case .presented:
            return nil
        }
    }
    
    private func position(_ proxy: GeometryProxy) -> CGPoint {
        switch transitionStatus {
        case .transitioning(let sourceRect):
            return .init(x: sourceRect.midX, y: sourceRect.midY)
        case .presented:
            return .init(x: proxy.frame(in: .global).midX, y: proxy.frame(in: .global).midY)
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                ItemView()
                    .frame(height: itemHeight)
                
                if self.transitionStatus == .presented {
                    ScrollView {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: itemHeight)
                        Text(self.contents)
                            .padding(16)
                            .frame(width: proxy.size.width)
                            .background(Color.white)
                    }.onDisappear(perform: self.didAnimated)
                }
            }
            .frame(width: self.size?.width, height: self.size?.height)
            .background(Color.white)
            .position(self.position(proxy))
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ItemView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottomLeading) {
                Image("tapioca")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 8.0) {
                    Text("今日の\nApp")
                        .foregroundColor(.white)
                        .font(.system(size: 48, weight: .bold))
                        .lineSpacing(4)
                        .padding(.leading, 16)
                    HStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                        VStack(alignment: .leading) {
                            Text("My Tapioca App")
                                .font(.headline)
                                .lineLimit(1)
                            Text("This is wonderful tapioca app.")
                                .font(.subheadline)
                                .lineLimit(1)
                        }.foregroundColor(.white)
                        Button(action: {
                            
                        }) {
                            Text("入手")
                        }
                        .padding([.top, .bottom], 4)
                        .padding([.leading, .trailing], 24)
                        .background(Color.white)
                        .cornerRadius(20)
                    }.padding(16)
                }
            }
        }
    }
}

struct AppStoreView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            DetailView(transitionStatus: .presented, didAnimated: {})
            ItemView()
        }
    }
}
