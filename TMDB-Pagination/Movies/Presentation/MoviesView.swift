//
//  MoviesView.swift
//  themdb-nicholas-rodriguez
//
//  Created by Nicolás A. Rodríguez on 4/12/21.
//

import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @State private var categoryFilter: Int = 1
    @State private var popularCurrentId = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0.0) {
                Picker(selection: $viewModel.selection, label: Text("")) {
                    Text("Popular").tag(MoviesViewModel.CategoryFilter.popular)
                    Text("Top Rated").tag(MoviesViewModel.CategoryFilter.topRated)
                    Text("On TV").tag(MoviesViewModel.CategoryFilter.onTV)
                    Text("Airing Today").tag(MoviesViewModel.CategoryFilter.airingToday)
                }.pickerStyle(SegmentedPickerStyle())
                .padding()
                
                switch viewModel.selection {
                case .popular:
                    ScrollView {
                        ScrollViewReader { (value: ScrollViewProxy) in
                            LazyVGrid(columns: [GridItem(), GridItem()]) {
                                ForEach(viewModel.popularMovies, id: \.id) { row in
                                    MovieView(movie: row)
                                        .id(row.id)
                                        .onAppear {
                                            popularCurrentId = row.id
                                            if (viewModel.popularMovies.last?.id ?? 0) == row.id {
                                                viewModel.$popularMoviesPage.nextPage()
                                                viewModel.getPopularMovies()
                                            }
                                        }
                                }
                            }.padding(.horizontal)
                            .onAppear {
                                value.scrollTo(popularCurrentId)
                            }
                        }
                        popularMoviesBottomRequestIndicatorView
                    }.onAppear {
                        viewModel.airingToday.isEmpty ? viewModel.getPopularMovies() : nil
                    }
                    
                case .topRated:
                    ScrollView {
                        LazyVGrid(columns: [GridItem(), GridItem()]) {
                            ForEach(viewModel.topRatedMovies, id: \.id) { row in
                                MovieView(movie: row)
                                    .onAppear {
                                        if (viewModel.topRatedMovies.last?.id ?? 0) == row.id {
                                            viewModel.$topRatedMoviesPage.nextPage()
                                            viewModel.getTopRatedMovies()
                                        }
                                    }
                            }
                        }.padding(.horizontal)
                        TopRatedMoviesBottomRequestIndicatorView
                    }.onAppear {
                        viewModel.topRatedMovies.isEmpty ? viewModel.getTopRatedMovies() : nil
                    }
                    
                case .onTV:
                    ScrollView {
                        LazyVGrid(columns: [GridItem(), GridItem()]) {
                            ForEach(viewModel.onTV, id: \.id) { row in
                                MovieView(movie: row)
                                    .onAppear {
                                        if (viewModel.onTV.last?.id ?? 0) == row.id {
                                            viewModel.$onTVPage.nextPage()
                                            viewModel.getOnTV()
                                        }
                                    }
                            }
                        }.padding(.horizontal)
                        onTVBottomRequestIndicatorView
                    }.onAppear {
                        viewModel.onTV.isEmpty ? viewModel.getOnTV() : nil
                    }
                    
                case .airingToday:
                    ScrollView {
                        LazyVGrid(columns: [GridItem(), GridItem()]) {
                            ForEach(viewModel.airingToday, id: \.id) { row in
                                MovieView(movie: row)
                                    .onAppear {
                                        if (viewModel.onTV.last?.id ?? 0) == row.id {
                                            viewModel.$airingTodayPage.nextPage()
                                            viewModel.getAiringToday()
                                        }
                                    }
                            }
                        }.padding(.horizontal)
                        airingTodayBottomRequestIndicatorView
                    }.onAppear {
                        viewModel.airingToday.isEmpty ? viewModel.getAiringToday() : nil
                    }
                }
            }.navigationBarTitle("TV Shows", displayMode: .inline)
        }
    }
    
    @ViewBuilder
    var popularMoviesBottomRequestIndicatorView: some View {
        if viewModel.$popularMoviesPage.isTheLastPage {
            Text("No more pages to show")
        } else {
            HStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Text("Requesting Movies.")
            }
        }
    }
    
    @ViewBuilder
    var TopRatedMoviesBottomRequestIndicatorView: some View {
        if viewModel.$topRatedMoviesPage.isTheLastPage {
            Text("No more pages to show")
        } else {
            HStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Text("Requesting Movies.")
            }
        }
    }
    
    @ViewBuilder
    var onTVBottomRequestIndicatorView: some View {
        if viewModel.$onTVPage.isTheLastPage {
            Text("No more pages to show")
        } else {
            HStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Text("Requesting Movies.")
            }
        }
    }
    
    @ViewBuilder
    var airingTodayBottomRequestIndicatorView: some View {
        if viewModel.$airingTodayPage.isTheLastPage {
            Text("No more pages to show")
        } else {
            HStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Text("Requesting Movies.")
            }
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
            .preferredColorScheme(.dark)
    }
}
