//
//  SearchView.swift
//  VoiceControlDemo
//
//  Created by Bogdan Sikora on 01.10.2025.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: CatViewModel
    @State private var searchQuery: String = ""

    var searchResults: [CatBreed] {
        viewModel.searchBreeds(query: searchQuery)
    }

    var body: some View {
        NavigationView {
            VStack {
                // ISSUE: Accessibility label says "Look for" but users will say "Search for"
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search for breeds...", text: $searchQuery)
                        .accessibilityLabel("Look for")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()

                List(searchResults) { breed in
                    NavigationLink(destination: BreedDetailView(breed: breed)) {
                        HStack {
                            Image(breed.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                                .clipped()

                            VStack(alignment: .leading) {
                                Text(breed.name)
                                    .font(.headline)
                                Text(breed.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Search Breeds")
        }
    }
}

struct BreedDetailView: View {
    let breed: CatBreed

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(breed.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .clipped()

                Text(breed.name)
                    .font(.title)
                    .fontWeight(.bold)

                Text(breed.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(breed.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SearchView(viewModel: CatViewModel())
}
