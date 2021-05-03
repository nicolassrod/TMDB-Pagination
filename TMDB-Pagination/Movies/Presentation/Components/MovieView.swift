//
//  MovieView.swift
//  themdb-nicholas-rodriguez
//
//  Created by Nicolás A. Rodríguez on 4/13/21.
//

import SwiftUI
import Kingfisher

struct MovieView: View {
    let movie: CustomMovieResponse
    
    var body: some View {
        VStack {
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .lastTextBaseline)) {
                KFImage(URL(string: "\(Constants.imagePath)\(movie.posterPath ?? "")"))
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .foregroundColor(.cgray)
                            .aspectRatio(CGSize(width: 175, height: 230), contentMode: .fit)
                            .cornerRadius(15, antialiased: true)
                    }
                    .aspectRatio(CGSize(width: 175, height: 230), contentMode: .fit)
                    .cornerRadius(15, antialiased: true)
                userScore
            }
            
            VStack(alignment: .leading) {
                Text("\(movie.title)")
                    .bold()
                
                Text("\(DateFormatter.customBasicDateFormat(from: movie.releaseDate))")
                    .padding(.top, 1)
                
                Text("\(movie.overview)")
                    .padding(.top, 1)
                    .padding(.bottom, 10)
                    .lineLimit(4)
                    .foregroundColor(Color.white)
            }.padding(.all, 3)
            .padding(.top, 10)
        }.cornerRadius(15, antialiased: true)
    }
    
    private var userScore: some View {
        ProgressRingView(progress: movie.voteAverage)
            .frame(width: 50, height: 50, alignment: .center)
            .padding(.horizontal, 10)
            .offset(x: 5, y: 20)
    }
}

struct MovieView_Previews: PreviewProvider {
    static let movie = PopularMovieResponse(
        posterPath: "/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg",
        adult: false,
        overview: "Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
        releaseDate: "1994-09-10",
        genreIDS: [18, 80],
        id: 278,
        originalTitle: "The Shawshank Redemption",
        originalLanguage: "en",
        title: "The Shawshank Redemption",
        backdropPath: "/xBKGJQsAIeweesB79KC89FpBrVr.jpg",
        popularity: 6.741296,
        voteCount: 5238,
        video: false,
        voteAverage: 8.32
    )
    
    static var previews: some View {
        MovieView(movie: movie)
            .padding(.horizontal)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
