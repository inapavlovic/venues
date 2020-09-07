
def shared
  platform :ios, '13.0'
  use_frameworks!

  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'

  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'

  pod 'IQKeyboardManagerSwift'
  pod 'Kingfisher', '~> 5.0'
  pod 'HorizonCalendar'
end

target 'vennu' do
  shared
  pod 'GooglePlaces'
end

target 'users' do
	shared
  pod 'Stripe'
end
