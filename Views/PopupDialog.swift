//
//  PopupDialog.swift
//  Events
//
//  Created by Tudor Popa on 09/08/2024.
//

import SwiftUI

extension PopupDialog {
    init(isPresented: Binding<Bool>,
         dismissOnTapOutside: Bool = true,
         @ViewBuilder _ content: () -> Content) {
        _isPresented = isPresented
        self.dismissOnOutsideTap = true
        self.content = content()
    }
}

struct PopupDialog<Content: View> : View {
    
    @Binding var isPresented: Bool
    let content: Content
    let dismissOnOutsideTap: Bool
    
    private let buttonSize: CGFloat = 24
    
    
    
    var body: some View {
        
        ZStack {

                    Rectangle()
                        .fill(.gray.opacity(0.7))
                        .ignoresSafeArea()
                        .onTapGesture {
                            if dismissOnOutsideTap {
                                withAnimation {
                                    isPresented = false
                                }
                            }
                        }

                    content
                        .frame(
                            width: UIScreen.main.bounds.size.width - 150, height: 100)
                        .padding()
                        .padding(.top, buttonSize)
                        .background(.white)
                        .cornerRadius(12)
                        .overlay(alignment: .topTrailing) {
                            Button(action: {
                                withAnimation {
                                    isPresented = false
                                }
                            }, label: {
                                Image(systemName: "xmark.circle")
                            })
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .foregroundStyle(Color.gray.opacity(0.7))
                            .padding(.all, 8)
                        }
                }
                .ignoresSafeArea(.all)
                .frame(
                    width: UIScreen.main.bounds.size.width,
                    height: UIScreen.main.bounds.size.height,
                    alignment: .center
                )
            }
    
    
        
    }


//#Preview {
  //  PopupDialog()
//}

