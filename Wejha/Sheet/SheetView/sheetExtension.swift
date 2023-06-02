//
//  sheetExtension.swift
//  buttom sheet
//
//  Created by roba on 15/05/2023.
//

import Foundation
import SwiftUI
//MARK: costume bottom sheet
extension View{
    @ViewBuilder
    func bottomSheet<Content:View>(
        presentationeDetents: Set<PresentationDetent>,
        isPresented: Binding<Bool>,
        dragIndicator: Visibility = .visible,
        sheetCornerRadius: CGFloat?,
        largesrUndimmedIdentifier: UISheetPresentationController.Detent.Identifier = .large,
        isTransparentBG: Bool = false,
        interactiveDisabled: Bool = true,
        @ViewBuilder content: @escaping ()->Content,
        onDismiss: @escaping ()->()
    )->some View{
        self
            .sheet(isPresented: isPresented){
                onDismiss()
            } content: {
                content()
                    .presentationDetents(presentationeDetents)
                    .presentationDragIndicator(dragIndicator)
                    .interactiveDismissDisabled(interactiveDisabled)
                    .background(Color.clear) // Add a transparent background
                    .onAppear{
                        //MARK: costume code for bottom sheet
                        //finding th presented view controller
                        guard let windows = UIApplication.shared.connectedScenes.first as?
                                UIWindowScene else{
                            return
                        }
                        //from extracting presentation controller
                        if let controller = windows.windows.first?.rootViewController? .presentedViewController, let sheet = controller.presentationController as? UISheetPresentationController{
                            
                            //remove tinted bg
                            controller.presentedViewController?.view.tintAdjustmentMode = .normal
                            //MARK: set properties to whatever u wish here w sheet controller
                            sheet.largestUndimmedDetentIdentifier = largesrUndimmedIdentifier
                            sheet.preferredCornerRadius = sheetCornerRadius
                        }
                        else {
                            print("NO CONTROLLER FOUND")
                        }
                    }
            }
        
    }
        
    
}
