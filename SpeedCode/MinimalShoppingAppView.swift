//
//  MinimalShoppingAppUI.swift
//  SpeedCode
//
//  Created by Takuya Yokoyama on 2020/03/18.
//  Copyright © 2020 Takuya Yokoyama. All rights reserved.
//

import SwiftUI

struct MinimalShoppingAppView: View {
    private let items: [Item] = [
        .init(id: UUID().uuidString, name: "M1300 AE", imageName: "item1", regularPrice: 33000, discountPrice: 30000),
        .init(id: UUID().uuidString, name: "M1300 AR", imageName: "item2", regularPrice: 33000, discountPrice: nil),
        .init(id: UUID().uuidString, name: "M1300 AE", imageName: "item1", regularPrice: 33000, discountPrice: 30000),
        .init(id: UUID().uuidString, name: "M1300 AR", imageName: "item2", regularPrice: 33000, discountPrice: nil),
        .init(id: UUID().uuidString, name: "M1300 AE", imageName: "item1", regularPrice: 33000, discountPrice: 30000),
        .init(id: UUID().uuidString, name: "M1300 AR", imageName: "item2", regularPrice: 33000, discountPrice: nil),
    ]
    
    var body: some View {
        TabView {
            GeometryReader { geometry in
                List {
                    Image("logo")
                        .listRowInsets(.init(top: 8, leading: 0, bottom: 16, trailing: 0))
                        .frame(width: geometry.size.width)
                    ForEach(self.items) { item in
                        VStack(alignment: .center, spacing: 4.0) {
                            Image(item.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 150)
                            Text(item.name)
                                .font(.body)
                            HStack {
                                Image(systemName: "heart")
                                Spacer()
                                VStack {
                                    if item.discountPrice != nil {
                                        Text("¥\(item.regularPrice)")
                                            .font(.subheadline)
                                            .strikethrough()
                                            .foregroundColor(.gray)
                                        Text("¥\(item.discountPrice!)")
                                            .font(.headline)
                                    } else {
                                        Text("¥\(item.regularPrice)")
                                            .font(.headline)
                                    }
                                }
                                Spacer()
                                Image(systemName: "cart")
                            }
                        }
                        .padding([.top, .bottom], 16)
                        .padding([.leading, .trailing], 32)
                        .background(Color.random)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .frame(width: geometry.size.width * 0.8)
                    }
                    .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                    .frame(width: geometry.size.width)
                }.onAppear {
                    UITableView.appearance().separatorColor = .clear
                }
            }.tabItem {
                Image(systemName: "house")
            }
            
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            
            Text("Favorite")
                .tabItem {
                    Image(systemName: "heart")
                }
            
            Text("Cart")
                .tabItem {
                    Image(systemName: "cart")
                }
            
            Text("Personal")
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

struct MinimalShoppingAppUIView_Previews: PreviewProvider {
    static var previews: some View {
        MinimalShoppingAppView()
    }
}

struct Item: Identifiable {
    let id: String
    let name: String
    let imageName: String
    let regularPrice: Int
    let discountPrice: Int?
}

extension Color {
    static var random: Color {
        .init(red: drand48(), green: drand48(), blue: drand48())
    }
}
