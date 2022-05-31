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
    let isHardPaywall: Bool
    var dismiss: (() -> Void)?
    
    public init(productIdWithTrial: String, productIdNoTrial: String, isHardPaywall: Bool, dismiss: @escaping (() -> Void)) {
        self.productIdWithTrial = productIdWithTrial
        self.productIdNoTrial = productIdNoTrial
        self.isHardPaywall = isHardPaywall
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
                        AppImageView(size: geometry.size.height / 5)
                            .padding(.top, 6)
                        Spacer()
                        GetAccessView(size: geometry.size.height / 25)
                        Spacer()
                        EnableFreeTrialView(isSelected: $trialIsSelected)
                        Spacer()
                        VStack(spacing: 4) {
							Text("try7DaysForFree")
								.font(.system(size: DZMonetization.UI.shouldUppercase ? 12 : 13, weight: .medium, design: DZMonetization.UI.fontDesign))
								.textCase(DZMonetization.UI.shouldUppercase ? .uppercase : .none)
								.foregroundColor(trialIsSelected ? DZMonetization.UI.textColor : .clear)
							PurchaseButton(showLoadingView: $showLoadingView, trialIsSelected: $trialIsSelected, frameWidth: geometry.size.width, loadingOverlayOpacity: $loadingOverlayOpacity, productIdWithTrial: productIdWithTrial, productIdNoTrial: productIdNoTrial, dismiss: dismiss)
                            if trialIsSelected {
                                Text("PriceDescription \(price)")
									.font(.system(size: DZMonetization.UI.shouldUppercase ? 13 : 14, weight: .semibold, design: DZMonetization.UI.fontDesign))
									.textCase(DZMonetization.UI.shouldUppercase ? .uppercase : .none)
                                    .foregroundColor(DZMonetization.UI.textColor)
                            } else {
                                Text("PriceDescriptionNoTrial \(price)")
									.font(.system(size: DZMonetization.UI.shouldUppercase ? 13 : 14, weight: .semibold, design: DZMonetization.UI.fontDesign))
									.textCase(DZMonetization.UI.shouldUppercase ? .uppercase : .none)
                                    .foregroundColor(DZMonetization.UI.textColor)
                            }
                            
                            HStack (spacing: 8) {
                                TermsAndConditionView()
                                Text("|")
                                    .font(.system(size: 11, weight: Font.Weight.medium, design: DZMonetization.UI.fontDesign))
                                    .foregroundColor(.black).opacity(0.9)
                                PolicyLinkView()
                            }
                            .padding(.top, 12)
                            .padding(.bottom, 4)
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                }
                if self.isHardPaywall == false {
                    DismissView(dismiss: dismiss, lessVisible: true, color: DZMonetization.UI.textColor, filled: false)
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
                DZAnalytics.purchaseFlowEvent(.ce_paywall_appear)
                InAppPuchase.shared.getPrice(for: self.productIdNoTrial) { (price) in
                    self.price = price
                }
            }
        }
    }

}

struct PurchaseButton: View {
	@Environment(\.presentationMode) var presentationMode
	@Binding var showLoadingView: Bool
	@Binding var trialIsSelected: Bool
	@State var frameWidth: CGFloat = 0
	@Binding var loadingOverlayOpacity: Double
	var productIdWithTrial: String
	var productIdNoTrial: String
	var dismiss: (() -> Void)?

	var body: some View {
		Button(action: {
			showLoadingView = true
			withAnimation {
				loadingOverlayOpacity = 0.9
			}
			simpleSuccess()
			
			let productId = self.trialIsSelected ? productIdWithTrial : productIdNoTrial
			DZAnalytics.purchaseFlowEvent(.ce_purchase_initialized, addedParameters: ["cp_product_id": productId])
			InAppPuchase.shared.purchaseProduct(withId: productId) { (didComplete, adjustSubObj) in
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
					.font(.system(size: DZMonetization.UI.shouldUppercase ? 22 : 24, weight: .bold, design: DZMonetization.UI.fontDesign))
					.textCase(DZMonetization.UI.shouldUppercase ? .uppercase : .none)
					.multilineTextAlignment(.center)
					.fixedSize(horizontal: false, vertical: true)
			}
			.padding(.vertical, 20)
			.frame(width: frameWidth - 50)
			.foregroundColor(DZMonetization.UI.textButtonColor)
			.background(DZMonetization.UI.accentGradient)
			.cornerRadius(DZMonetization.UI.buttonRadius)
			.shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
		})
	}
	
	func simpleSuccess() {
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.success)
	}
	
}

struct AppImageView: View {
	@State var size: CGFloat
	
	var body: some View {
		Image("paywall-image")
			.resizable()
			.scaledToFit()
			.frame(height: size)
	}
}

struct GetAccessView: View {
	@State var size: CGFloat = DZMonetization.UI.shouldUppercase ? 29 : 32
    
    var body: some View {
        VStack {
            Text("GetAccessTo")
                .font(.system(size: size, weight: .semibold, design: DZMonetization.UI.fontDesign))
				.textCase(DZMonetization.UI.shouldUppercase ? .uppercase : .none)
                .foregroundColor(DZMonetization.UI.textColor)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 8)
            Text("AppName")
                .font(.system(size: size + 8, weight: .black, design: DZMonetization.UI.fontDesign))
				.textCase(DZMonetization.UI.shouldUppercase ? .uppercase : .none)
                .foregroundColor(DZMonetization.UI.textColor)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            if "AppNameDescription".localizedLowercase != "" {
                Text("AppNameDescription")
					.font(.system(size: size + 2, weight: DZMonetization.UI.descriptionWeight, design: DZMonetization.UI.fontDesign))
					.textCase(DZMonetization.UI.shouldUppercase ? .uppercase : .none)
                    .foregroundColor(DZMonetization.UI.textColor)
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
                .font(.system(size: 17, weight: Font.Weight.semibold, design: DZMonetization.UI.fontDesign))
				.textCase(DZMonetization.UI.shouldUppercase ? .uppercase : .none)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(DZMonetization.UI.textColor)
            Spacer()
            Toggle("", isOn: $isSelected)
                .toggleStyle(CheckmarkToggleStyle())
                .frame(maxWidth: 80)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(DZMonetization.UI.enableTrialBoxBackground)
		.cornerRadius(DZMonetization.UI.buttonRadius)
        .overlay(
            RoundedRectangle(cornerRadius: DZMonetization.UI.buttonRadius)
                .stroke(DZMonetization.UI.borderColor, lineWidth: 1)
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
                .foregroundColor(configuration.isOn ? DZMonetization.UI.accent : DZMonetization.UI.accent.opacity(0.32))
                .frame(width: 54, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
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
				.font(.system(size: DZMonetization.UI.shouldUppercase ? 11 : 12, weight: Font.Weight.medium, design: DZMonetization.UI.fontDesign))
				.underline()
				.textCase(DZMonetization.UI.shouldUppercase ? .uppercase : .none)
                .foregroundColor(DZMonetization.UI.textColor.opacity(0.9))
        })
            .padding(.vertical, 12)
            .alert(isPresented: self.$showAlert) {
                Alert(title: Text(DZMonetization.AppData.shared.isPremium() ? "Purchase restored succesfully" : "No purchases to restore"))
            }
    }
}

struct TermsAndConditionView: View {
    @State private var isShowingTerms = false
    
    var body: some View {
        Button(action: {
            isShowingTerms = true
        }, label: {
            Text("Terms & Conditions")
				.font(.system(size: DZMonetization.UI.shouldUppercase ? 10 : 11, weight: Font.Weight.medium, design: DZMonetization.UI.fontDesign))
				.underline()
				.textCase(DZMonetization.UI.shouldUppercase ? .uppercase : .none)
                .foregroundColor(DZMonetization.UI.textColor).opacity(0.9)
        })
            .sheet(isPresented: self.$isShowingTerms, content: {
                TermsView(isShowingView: $isShowingTerms)
            })
    }
}

struct PolicyLinkView: View {
    @State private var isShowingPolicy = false
    
    var body: some View {
        Button(action: {
            isShowingPolicy = true
        }, label: {
            Text("Privacy Policy")
				.font(.system(size: DZMonetization.UI.shouldUppercase ? 10 : 11, weight: Font.Weight.medium, design: DZMonetization.UI.fontDesign))
				.underline()
				.textCase(DZMonetization.UI.shouldUppercase ? .uppercase : .none)
                .foregroundColor(DZMonetization.UI.textColor).opacity(0.9)
        })
            .sheet(isPresented: self.$isShowingPolicy, content: {
                PolicyView(isShowingView: $isShowingPolicy)
            })
    }
}

struct DismissView: View {
    var dismiss: (() -> Void)?
    var lessVisible: Bool = false
    @State var color: Color
    @State var filled: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack() {
                if let dismiss = dismiss {
                    Button {
                        DZAnalytics.purchaseFlowEvent(.ce_paywall_dismissed)
                        dismiss()
                    } label: {
                        Image(systemName: filled ? "xmark.circle.fill": "xmark")
                            .font(.system(size: lessVisible ? 20 : 22))
                            .foregroundColor(color).opacity(lessVisible ? 0.4 : 0.68)
                            .padding(.leading, 16)
                            .padding(.top, 14)
                    }
                } else {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: filled ? "xmark.circle.fill" : "xmark")
                            .font(.system(size: lessVisible ? 20 : 22))
                            .foregroundColor(color).opacity(lessVisible ? 0.4 : 0.68)
                            .padding(.leading, 16)
                            .padding(.top, 14)
                    })
                }
                Spacer()
            }
            Spacer()
        }
        .onAppear {
            print("lessVisible: \(lessVisible)")
        }
    }
}
