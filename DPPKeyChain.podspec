Pod::Spec.new do |s|
  s.name         = "DPPKeyChain"
  s.version      = "0.0.1"
  s.summary      = "DPPKeychain contains a series of classes used for manage easily the iOS keychain and TouchID auth."
  s.description  = <<-DESC
		DPPKeychain contains a series of classes used for manage easily the iOS keychain and TouchID auth. The classes are:
			- DPPKeychainManager, a wrapper for basic operation with iOS keychain (save, retrieve, update, delete).
			- DPPKeychainItem, a model class that represents keychain item.
			- DPPTouchIdManager, a wrapper for LocalAuthentication framework. It's a singleton.
	DESC
  s.homepage     = "https://github.com/dpizzuto/DPPKeychain"
  s.author       = { "Dario Pizzuto" => "" }
  s.social_media_url = 'https://twitter.com/DarioPizzuto'
  s.source       = { :git => "https://github.com/dpizzuto/DPPKeychain.git", :tag => s.version.to_s }
  s.source_files = 'DPPKeychain'
  s.platform     = :ios, '8.1'
  s.requires_arc = true
  s.license      = {
     :type => 'MIT',
     :text => <<-LICENSE
               Copyright (c) 2014 Dario Pizzuto
                      Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
                      associated documentation files (the "Software"), to deal in the Software without restriction,
                      including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
                      and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
                      subject to the following conditions:
                      The above copyright notice and this permission notice shall be included in all copies or substantial
                      portions of the Software.
                      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
                      LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
                      IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
                      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
                      SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.     
LICENSE
   }
end
