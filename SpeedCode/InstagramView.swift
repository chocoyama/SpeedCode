//
//  InstagramUI.swift
//  SpeedCode
//
//  Created by Takuya Yokoyama on 2020/04/02.
//  Copyright © 2020 Takuya Yokoyama. All rights reserved.
//

import SwiftUI

struct InstagramView: View {
    @State private var showingStoryView = false
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0.0) {
                            Spacer().frame(width: 16)
                            HStack(spacing: 16) {
                                Button(action: {
                                    withAnimation {
                                        self.showingStoryView = true
                                    }
                                }) {
                                    MyStoryItemView()
                                }
                                ForEach(0..<4) { _ in
                                    StoryItemView(title: "ユーザー", viewed: false)
                                }
                                ForEach(0..<4) { _ in
                                    StoryItemView(title: "ユーザー", viewed: true)
                                }
                            }
                            Spacer().frame(width: 16)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .frame(height: 96)
                    
                    ForEach(0..<10) { _ in
                        PostView(name: "Instagrammer")
                    }
                }
                .navigationBarTitle("Instagram", displayMode: .inline)
                .navigationBarItems(
                    leading: Image(systemName: "camera"),
                    trailing: Image(systemName: "paperplane")
                )
            }
            
            if showingStoryView {
                StoryPageView()
                    .edgesIgnoringSafeArea(.all)
                    .transition(.scale)
            }
        }
    }
}

struct InstagramView_Previews: PreviewProvider {
    static var previews: some View {
        InstagramView()
    }
}

struct MyStoryItemView: View {
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.black)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 58, height: 58)
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .padding(4)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            Text("ストーリーズ")
                .font(.system(size: 9))
                .foregroundColor(.gray)
        }
    }
}

struct StoryItemView: View {
    let title: String
    let viewed: Bool
    
    var body: some View {
        VStack {
            Circle()
                .fill(viewed ? Color(white: 0.9) : Color.orange)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 58, height: 58)
                )
                .frame(width: 60, height: 60)
            Text(title)
                .font(.system(size: 9))
                .foregroundColor(viewed ? .gray : .black)
        }
    }
}

struct PostView: View {
    let name: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .frame(width: 32, height: 32)
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.system(size: 14))
                }
            }
            Image("sakura")
                .resizable()
                .aspectRatio(contentMode: .fill)
            HStack(spacing: 8.0) {
                Group {
                    Image(systemName: "heart")
                    Image(systemName: "bubble.right")
                    Image(systemName: "paperplane")
                    Spacer()
                    Image(systemName: "bookmark")
                }.padding(4)
            }.padding([.top, .bottom], 8)
            HStack {
                Image(systemName: "person").frame(width: 15, height: 15)
                Text("YouTuber他").font(.system(size: 14, weight: .bold))
                Text("が「いいね！」しました").font(.system(size: 12))
            }
            HStack {
                Text(name).font(.system(size: 14, weight: .bold))
                Group {
                    Text("週末に行ってきました！")
                    Text("...")
                    Text("続きを読む").foregroundColor(.gray)
                }.font(.system(size: 12))
            }.padding(.bottom, 8)
            VStack(alignment: .leading, spacing: 8.0) {
                Text("コメント88件すべてを表示")
                Text("2時間前")
            }
            .font(.system(size: 12))
            .foregroundColor(.gray)
        }.padding([.top, .bottom], 8)
    }
}

import AVKit
struct AVPlayerView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        vc.showsPlaybackControls = false
        vc.player = AVPlayer(url: url)
        vc.player?.play()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    }
}

struct PageView: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
        let view: PageView
        
        init(_ view: PageView) {
            self.view = view
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = view.controllers.firstIndex(of: viewController) else { return nil }
            return index == 0 ? nil : view.controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = view.controllers.firstIndex(of: viewController) else { return nil }
            return index + 1 == view.controllers.count ? nil : view.controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
                let visibleVC = pageViewController.viewControllers?.first,
                let index = view.controllers.firstIndex(of: visibleVC) {
                view.currentPage = index
            }
        }
    }
    
    let controllers: [UIViewController]
    @State var currentPage: Int = 0
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.dataSource = context.coordinator
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: true)
    }
}

struct Story {
    let comment: String
    let videoUrl: URL
}

struct StoryView: View {
    let story: Story
    
    var body: some View {
        ZStack {
            AVPlayerView(url: story.videoUrl)
            Text(story.comment)
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}


struct StoryPageView: View {
    private let stories = [
        Story(comment: "寒い", videoUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "1", ofType: "mov")!)),
        Story(comment: "Happy Birthday!!", videoUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "2", ofType: "mp4")!)),
        Story(comment: "明日は8時出勤😇", videoUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "3", ofType: "mov")!)),
    ]
    
    var body: some View {
        PageView(
            controllers: stories
                .map { StoryView(story: $0) }
                .map { UIHostingController(rootView: $0) }
        ).edgesIgnoringSafeArea(.all)
    }
}
