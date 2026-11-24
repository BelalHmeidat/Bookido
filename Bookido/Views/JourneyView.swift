//
//  JourneyView.swift
//  Bookido
//
//  Created by Stefania Rosciano on 23/11/2026.
//

import SwiftUI

struct JourneyView : View {
    
    var body : some View {
        
        ZStack {
            
            SketchTheme.mainBackground
                .ignoresSafeArea()
            
            VStack {
                
                HStack (alignment : .center) {
                    
                    Button {
                        // navigation to shelf
                    } label : {
                        
                        Text("\(Image(systemName: "books.vertical"))")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundStyle(SketchTheme.darkBackground)
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial, in: Circle())
                            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                    
                    Spacer()
                    
                    
                    VStack {
                        
                        Text("Journey")
                            .font(.system(.title, design: .serif, weight: .bold))
                            .foregroundStyle(SketchTheme.primaryAccent)
                        
                        Text("Some progress indicator")
                            .font(.system(.footnote, design: .rounded, weight: .regular))
                            .foregroundStyle(SketchTheme.primaryAccent)
                    }
                    
                    
                    Spacer()
                    
                    Menu {
                        
                        Button {
                            //pass
                        } label : {
                            Label("Mysteries", systemImage: "magnifyingglass")
                        }
                        
                        Button {
                            //pass
                        } label : {
                            Label("Characters", systemImage: "person.2")
                        }
                        
                        Button {
                            //pass
                        } label : {
                            Label("Locations", systemImage: "map")
                        }
                        
                        
                    } label : {
                        Text("\(Image(systemName: "line.3.horizontal"))")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundStyle(SketchTheme.darkBackground)
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial, in: Circle())
                            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                    
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                ScrollView {
                    
                    VStack {
                        
                        ZStack (alignment : .topLeading) {
                            
                            
                            Path { path in
                                path.move(to: CGPoint(x: 44, y: 28))
                                path.addQuadCurve(
                                    to: CGPoint(x: 185, y: 180),
                                    control: CGPoint(x: 44, y: 135)
                                )
                            }
                            .stroke(
                                SketchTheme.primaryAccent,
                                style: StrokeStyle(lineWidth: 1.5, dash: [4, 4])
                            )
                            
                            HStack {
                                
                                HStack (spacing: 8) {
                                    
                                    NodeView(isRegularNode: true)
                                    
                                    Text("Start")
                                        .font(.system(.callout, design: .rounded, weight: .semibold))
                                        .foregroundStyle(SketchTheme.primaryAccent)
                                    
                                }
                                .padding(.leading, 30)
                                
                                Spacer()
                                
                                Circle()
                                    .frame(width : 100, height: 80)
                                    .foregroundStyle(SketchTheme.darkBackground)
                                    .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
                                    .padding(.trailing, 24)
                            
                                
                            }
                            
                            
                            
                        }
                        .frame(height: 190)
                        .padding(.top, 20)
                        
                        
                        CurrentNodeCardView()
                        
                        VStack(spacing: 0) {
                            // Vertical dashed connector line
                            Path { path in
                                path.move(to: CGPoint(x: 1, y: -6))
                                path.addLine(to: CGPoint(x: 1, y: 36))
                            }
                            .stroke(
                                SketchTheme.primaryAccent,
                                style: StrokeStyle(lineWidth: 1.5, dash: [4, 4])
                            )
                            .frame(width: 2, height: 36)

                            // Mystery Node (or NodeView(isRegularNode: false))
                            Button {
                                // pass
                            } label: {
                                VStack(spacing: 6) {
                                    NodeView(isRegularNode: false)

                                    Text("Mystery")
                                        .font(.system(.caption, design: .rounded, weight: .bold))
                                        .foregroundStyle(SketchTheme.primaryAccent)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
}

#Preview {
    JourneyView()
}
