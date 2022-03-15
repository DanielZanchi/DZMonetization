//
//  File.swift
//  
//
//  Created by Daniel Zanchi on 14/03/22.
//

import SwiftUI
import DZDataAnalytics

public struct EnableTrialPaywallView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var shouldShowLoadingView: Bool = false
    @State private var price: String = ""
    @State private var loadingOverlayOpacity: Double = 0.0
    @State private var showLoadingView = false
    @State private var trialIsSelected = false
    let productIdNoTrial: String
    let productIdWithTrial: String
    var dismiss: (() -> Void)?
    
    public init(productIdWithTrial: String, productIdNoTrial: String, dismiss: @escaping (() -> Void)) {
        self.productIdWithTrial = productIdWithTrial
        self.productIdNoTrial = productIdNoTrial
        self.dismiss = dismiss
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 12) {
                        RestoreButtonView(dismiss: dismiss, showLoadingView: $showLoadingView)
                            .padding(.top)
                        AppImageNoTextView(size: geometry.size.height / 4.4)
                            .padding(.top, 6)
                        Spacer()
                        GetAccessView(size: geometry.size.height / 25)
                        Spacer()
                        EnableFreeTrialView(isSelected: $trialIsSelected)
                        Spacer()
                        VStack(spacing: 4) {
                            Text("try7DaysForFree")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(trialIsSelected ? .white : .clear)
                            Button(action: {
                                showLoadingView = true
                                withAnimation {
                                    loadingOverlayOpacity = 0.9
                                }
                                simpleSuccess()
                                
                                let productId = self.trialIsSelected ? productIdWithTrial : productIdNoTrial
                                DZAnalytics.purchaseInitialized(productId: productId)
                                InAppPuchase.shared.purchaseProduct(withId: productId) { (didComplete) in
                                    if didComplete {
                                        if let dismiss = dismiss {
                                            dismiss()
                                        } else {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    } else {
                                        showLoadingView = false
                                    }
                                }
                            }, label: {
                                VStack(spacing: 2) {
                                    Text(trialIsSelected ? "startButton" : "Continue")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.vertical, 20)
                                .frame(width: geometry.size.width - 50)
                                .foregroundColor(Color.white)
                                .background(DZMonetization.UI.accentGradient)
                                .cornerRadius(18)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            })
                            if trialIsSelected {
                            Text("PriceDescription \(price)")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            } else {
                                Text("PriceDescriptionNoTrial \(price)")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            HStack (spacing: 8) {
                                TermsAndConditionView()
                                Text("|")
                                    .font(.system(size: 11, weight: Font.Weight.medium, design: Font.Design.rounded))
                                    .foregroundColor(.black).opacity(0.9)
                                PolicyLinkView()
                            }
                            .padding(.top, 12)
                            .padding(.bottom, 4)
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
            .overlay(
                Group {
                    if showLoadingView {
                        ZStack {
                            if #available(iOS 14.0, *) {
                                Color(.black)
                                    .opacity(loadingOverlayOpacity)
                                    .ignoresSafeArea()
                            } else {
                                Color(.black)
                                    .opacity(loadingOverlayOpacity)
                            }
                            iActivityIndicator(style: .rotatingShapes(count: 5, size: 12))
                                .frame(width: 90, height: 90, alignment: .center)
                                .foregroundColor(DZMonetization.UI.accent)
                        }
                    }
                }
            )
            .onAppear {
                InAppPuchase.shared.getPrice(for: self.productIdNoTrial) { (price) in
                    self.price = price
                }
            }
        }
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

struct AppImageNoTextView: View {
    @State var size: CGFloat
    
    var body: some View {
        ZStack {
            Image("paywall-image")
                .resizable()
                .scaledToFit()
                .frame(height: size)
        }
  
    }
}

struct GetAccessView: View {
    @State var size: CGFloat = 32
    
    var body: some View {
        VStack {
            Text("GetAccessTo")
                .font(.system(size: size, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 8)
            Text("AppName")
                .font(.system(size: size + 8, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            if "AppNameDescription".localizedLowercase != "" {
                Text("AppNameDescription")
                    .font(.system(size: size + 2, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct EnableFreeTrialView: View {
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(isSelected ? "EnabledFreeTrial" : "EnableFreeTrial")
                .font(.system(size: 18, weight: Font.Weight.semibold, design: .rounded))
                .foregroundColor(.white)
            Spacer()
            if #available(iOS 15.0, *) {
                Toggle("", isOn: $isSelected)
                    .toggleStyle(CheckmarkToggleStyle())
                    .frame(maxWidth: 80)
            } else {
                if #available(iOS 14.0, *) {
                    Toggle("", isOn: $isSelected)
                        .toggleStyle(CheckmarkToggleStyle())
                } else {
                    Toggle("", isOn: $isSelected)
                        .toggleStyle(CheckmarkToggleStyle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(DZMonetization.UI.enableTrialBoxBackground)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white, lineWidth: 1)
        )
        .padding(.horizontal, 25)
        .onTapGesture {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            isSelected.toggle()
        }
    }
}


struct CheckmarkToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? DZMonetization.UI.accent : .white.opacity(0.62))
                .frame(width: 54, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
//                        .overlay(
//                            Image(systemName: configuration.isOn ? "checkmark" : "xmark")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .font(Font.title.weight(.black))
//                                .frame(width: 8, height: 8, alignment: .center)
//                                .foregroundColor(configuration.isOn ? Color.Custom.paywallAccent : .gray)
//                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.spring(response: 0.2, dampingFraction: 0.56, blendDuration: 0.12))
                        
                ).cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
    
}

struct BackgroundView: View {
    var body: some View {
        if #available(iOS 14.0, *) {
            DZMonetization.UI.paywallBackground
                .ignoresSafeArea()
        } else {
            DZMonetization.UI.paywallBackground
        }
    }
}

struct RestoreButtonView: View {
    var dismiss: (() -> Void)?
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @Binding var showLoadingView: Bool

    var body: some View {
        Button(action: {
            showLoadingView = true
            InAppPuchase.shared.restorePurchases() {
                showLoadingView = false
                if DZMonetization.AppData.shared.isPremium() == true {
                    if let dismiss = dismiss {
                        dismiss()
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    showAlert.toggle()
                }
            }
        }, label: {
            Text("RestorePurchase")
                .font(.system(size: 12, weight: Font.Weight.medium, design: Font.Design.rounded))
                .underline()
                .foregroundColor(.white.opacity(0.9))
        })
            .padding(.vertical, 12)
            .alert(isPresented: self.$showAlert) {
                Alert(title: Text(DZMonetization.AppData.shared.isPremium() ? "Purchase restored succesfully" : "No purchases to restore"))
            }
    }
}

struct TermsAndConditionView: View {
    @State private var isShowingTerms = false
    private let titleColor = Color.white
    
    var body: some View {
        Button(action: {
            isShowingTerms = true
        }, label: {
            Text("Terms & Conditions")
                .font(.system(size: 11, weight: Font.Weight.medium, design: Font.Design.rounded))
                .underline()
                .foregroundColor(titleColor).opacity(0.9)
        })
            .sheet(isPresented: self.$isShowingTerms, content: {
                TermsView(isShowingView: $isShowingTerms)
            })
    }
}

struct PolicyLinkView: View {
    @State private var isShowingPolicy = false
    private let titleColor = Color.white
    
    var body: some View {
        Button(action: {
            isShowingPolicy = true
        }, label: {
            Text("Privacy Policy")
                .font(.system(size: 11, weight: Font.Weight.medium, design: Font.Design.rounded))
                .underline()
                .foregroundColor(titleColor).opacity(0.9)
        })
            .sheet(isPresented: self.$isShowingPolicy, content: {
                PolicyView(isShowingView: $isShowingPolicy)
            })
    }
}

