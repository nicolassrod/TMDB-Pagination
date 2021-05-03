//
//  ProgressRingView.swift
//  themdb-nicholas-rodriguez
//
//  Created by Nicolás A. Rodríguez on 4/15/21.
//

import SwiftUI

struct ProgressRingView: View {
    @State private var privateProgress: Double = 0.0
    private var adjustedProgress: Double {
        min(max(0, self.privateProgress), 1)
    }
    var progress: Double = 0.0
    
    init(progress: Double) {
        self.progress = progress / 10
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ProgressRingShape(progress: adjustedProgress)
                    .stroke(style: ringStrokeStyle(geometry))
                    .foregroundColor(rigColor)
                    .animation(privateProgress == 0.0 ? nil : Animation.linear(duration: 1.0).delay(1.0))
                    .background(
                        ProgressRingShape(progress: 1)
                            .stroke(style: ringStrokeStyle(geometry))
                            .foregroundColor(.gray)
                    ).padding(ringPadding(geometry))
                    .background(Circle().foregroundColor(.black))
                    .animation(nil)
                percentageText
            }
        }.onAppear {
            privateProgress = progress
        }
    }
    
    private var percentageText: some View {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let number = NSNumber(value: privateProgress * 100)
        
        return HStack(alignment: .top, spacing: 1) {
            Text(number, formatter: formatter)
                .font(.system(.callout, design: .rounded))
                .fontWeight(.bold)
            Text("%")
                .font(.system(.caption2, design: .rounded))
        }.foregroundColor(.white)
        .animation(nil)
    }
    
    private var rigColor: Color {
        if 0...0.2 ~= privateProgress {
            return Color.red
        } else if 0.2...0.6 ~= privateProgress {
            return Color.yellow
        } else {
            return Color.green
        }
    }
    
    private func ringPadding(_ geometry: GeometryProxy) -> CGFloat {
        (ringLineWidth(geometry) / 2) * 2
    }
    
    private func ringLineWidth(_ geometry: GeometryProxy) -> CGFloat {
        let smallestDimension = min(geometry.size.width, geometry.size.height)
        return max(smallestDimension / 10, 1)
    }
    
    private func ringStrokeStyle(_ geometry: GeometryProxy) -> StrokeStyle {
        StrokeStyle(lineWidth: ringLineWidth(geometry), lineCap: .round)
    }
}

struct ProgressRingShape: Shape {
    var progress: Double
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        guard progress > .zero else {
            return Path()
        }
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.size.width, rect.size.height) / 2
        let startAngle = Angle.degrees(-90)
        let endAngle = startAngle + .degrees(360 * progress)
        
        var path = Path()
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        return path
    }
}

struct ProgressRingView_Previews: PreviewProvider {
    @State static var redProgress: Double = 0.17
    @State static var yellowProgress: Double = 0.4
    @State static var greenProgress: Double = 0.8
    
    static var previews: some View {
        ProgressRingView(progress: redProgress)
            .frame(width: 60, height: 60, alignment: .center)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
        
        ProgressRingView(progress: yellowProgress)
            .frame(width: 60, height: 60, alignment: .center)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
        
        ProgressRingView(progress: greenProgress)
            .frame(width: 60, height: 60, alignment: .center)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
