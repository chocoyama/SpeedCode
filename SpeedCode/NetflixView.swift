//
//  NetflixView.swift
//  SpeedCode
//
//  Created by Takuya Yokoyama on 2020/03/21.
//  Copyright © 2020 Takuya Yokoyama. All rights reserved.
//

import SwiftUI

struct Movie {
    let title: String
    let thumbnail: String
    let url: URL?
    
    static let sample1 = Movie(title: "ゴレンジャーシングス", thumbnail: "movie1", url: nil)
    static let sample2 = Movie(title: "Mild Speed", thumbnail: "movie2", url: nil)
    static let sample3 = Movie(title: "半裸監督", thumbnail: "movie3", url: nil)
    static let sample4 = Movie(title: "Stove Jobs", thumbnail: "movie4", url: nil)
    static let sample5 = Movie(title: "回転男", thumbnail: "movie5", url: URL(fileURLWithPath: Bundle.main.path(forResource: "movie", ofType: "mp4")!))
    static let all: [Movie] = [.sample2, .sample3, .sample4, .sample5, .sample1]
}

struct NetflixView: View {
    @State private var isPlaying = false
    @State private var offset: CGPoint = .zero
    private var headerOpacity: Double {
        1.0 - (Double(offset.y) / 300)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
//            ScrollView(showsIndicators: false) {
            ObservableScrollView(showsIndicators: false, offset: $offset) {
                RecommendView(movie: .sample1)
                VStack(spacing: 20.0) {
                    PreviewItemCarouselView(movies: Movie.all)
                    ItemCarouselView(title: "人気急上昇中の作品", movies: Movie.all)
                    PreviewView(title: "配信中: シーズン1", movie: .sample5, isPlaying: self.$isPlaying)
                        .onAppear {
                            self.isPlaying = true
                        }
                    ItemCarouselView(title: "マイリスト", movies: Movie.all)
                    ItemCarouselView(title: "もう一度見る", movies: Movie.all)
                }.foregroundColor(.white)
            }
            .background(Color(white: 0.1))
            .edgesIgnoringSafeArea(.all)
            
            HStack {
                Text("N")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
                Spacer()
                Text("TV番組・ドラマ")
                Spacer()
                Text("映画")
                Spacer()
                Text("マイリスト")
            }
            .padding([.leading, .trailing], 16)
            .foregroundColor(.white)
            .opacity(headerOpacity)
        }
    }
}

struct RecommendView: View {
    let movie: Movie
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(movie.thumbnail)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
            
            VStack {
                Text(movie.title)
                    .font(.largeTitle)
                    .padding(.bottom, 16)
                Text("身の毛のよだつ・エキサイティング")
                    .font(.subheadline)
                    .padding(.bottom, 16)
                HStack {
                    VStack {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("マイリスト")
                            .font(.footnote)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "play.fill")
                        Text("再生")
                    }
                    .padding([.top, .bottom], 8)
                    .padding([.leading, .trailing], 32)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(4)
                    Spacer()
                    VStack {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("詳細情報")
                            .font(.footnote)
                    }
                }
                .padding(.bottom, 16)
                .padding([.leading, .trailing], 24)
            }.foregroundColor(.white)
        }
    }
}

struct PreviewItemCarouselView: View {
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("プレビュー")
                .bold()
                .padding(.leading, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0.0) {
                    Spacer().frame(width: 8)
                    HStack(spacing: 12.0) {
                        ForEach(movies, id: \.title) { movie in
                            ZStack(alignment: .bottom) {
                                Image(movie.thumbnail)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 120, height: 120)
                                    .padding(.bottom, 10)
                                Text(movie.title)
                                    .font(.headline)
                                    .bold()
                                    .lineLimit(1)
                                    .frame(maxWidth: 120)
                            }
                        }
                    }
                    Spacer().frame(width: 8)
                }
            }
        }
    }
}

struct ItemCarouselView: View {
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                .padding(.leading, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0.0) {
                    Spacer().frame(width: 8)
                    HStack {
                        ForEach(movies, id: \.title) { movie in
                            Image(movie.thumbnail)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 160)
                                .clipped()
                        }
                    }
                    Spacer().frame(width: 8)
                }
            }
        }
    }
}

import AVKit
struct PreviewView: View {
    let title: String
    let movie: Movie
    @Binding var isPlaying: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                .padding(.leading, 8)
            
            AVPlayerView(url: movie.url!, isPlaying: isPlaying)
                .frame(height: 240)
            
            HStack {
                HStack {
                    Image(systemName: "play.fill")
                    Text("再生")
                }
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing], 32)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(4)
                
                HStack {
                    Image(systemName: "plus")
                    Text("マイリスト")
                }
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing], 32)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(4)
            }.padding(8)
        }
    }
    
    struct AVPlayerView: UIViewControllerRepresentable {
        let url: URL
        let isPlaying: Bool
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<PreviewView.AVPlayerView>) -> AVPlayerViewController {
            let viewController = AVPlayerViewController()
            viewController.showsPlaybackControls = false
            viewController.player = AVPlayer(url: url)
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<PreviewView.AVPlayerView>) {
            uiViewController.player?.pause()
            if isPlaying {
                uiViewController.player?.play()
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGPoint]
    
    static var defaultValue: [CGPoint] = [.zero]
    
    static func reduce(value: inout [CGPoint], nextValue: () -> [CGPoint]) {
        value.append(contentsOf: nextValue())
    }
}

struct ObservableScrollView<Content>: View where Content: View {
    private let axes: Axis.Set
    private let showsIndicators: Bool
    @Binding private var offset: CGPoint
    private let content: () -> Content
    
    init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        offset: Binding<CGPoint>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self._offset = offset
        self.content = content
    }
    
    var body: some View {
        GeometryReader { parentProxy in
            ScrollView(self.axes, showsIndicators: self.showsIndicators) {
                VStack(spacing: 0.0) {
                    GeometryReader { proxy -> AnyView in
                        let frame = proxy.frame(in: .global)
                        let offset = CGPoint(x: -frame.minX, y: -frame.minY)
                        return AnyView(
                            Text("")
                                .preference(key: ScrollOffsetPreferenceKey.self, value: [offset])
                        )
                    }.frame(height: 0)
                    self.content()
                }.frame(width: parentProxy.size.width)
            }.onPreferenceChange(ScrollOffsetPreferenceKey.self) { (offsets) in
                self.offset = CGPoint(x: offsets[0].x, y: offsets[0].y)
            }
        }
    }
}

struct NetflixView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            VStack {
                PreviewItemCarouselView(movies: Movie.all)
                ItemCarouselView(title: "title", movies: Movie.all)
                PreviewView(title: "title", movie: .sample5, isPlaying: .constant(false))
            }
            .foregroundColor(.white)
            .background(Color(white: 0.1))
        }
    }
}
