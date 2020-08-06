
import Foundation
import UIKit

public extension String {
	//MARK:- Test
      func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
      func isBlankString()-> Bool {
        return self.trim().count == 0
    }
    
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
        
    }
    
    func addSpaceInCharector(value:CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length))
       
        return  attributedString
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    func getDateStringFromTimeStamp(dateformat:String)->String
    {
        let timestamp=Double(self)
        
        
        guard timestamp != nil else {
            return "\(Date())"
        }
        
        let date = Date(timeIntervalSince1970: Double(self)!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current//TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = dateformat//"yyyy-MM-dd HH:mm"          //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    
    // MARK:- String class extension for capitalizing first character
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    // MARK:- String class extension for capitalizing first character
    func smallizationFirstLetter() -> String {
        let first = String(prefix(1)).lowercased()
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
     static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
     func substring(_ from: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: from)])
    }
    
     func startWith(_ find: String) -> Bool {
        return self.hasPrefix(find)
    }
    
     func equals(_ find: String) -> Bool {
        return self == find
    }
    
     func contains(_ find: String) -> Bool {
        if let _ = self.range(of: find) {
            return true
        }
        return false
    }
    
     var length: Int {
        return self.count
    }
    
     var str: NSString {
        return self as NSString
    }
     var pathExtension: String {
        return str.pathExtension 
    }
     var lastPathComponent: String {
        return str.lastPathComponent 
    }
    
     func boolValue() -> Bool? {
        var returnValue:Bool = false
        let falseValues = ["false", "no", "0"]
        let lowerSelf = self.lowercased()
        
        if falseValues.contains(lowerSelf) {
            returnValue =  false
        } else {
            returnValue = true
        }
        return returnValue
    }
    
     var floatValue: Float {
        return (self as NSString).floatValue
    }
     var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
     var intValue: Int {
        return (self as NSString).integerValue
    }
     
    
    func URLEncodedString() -> String {
        let customAllowedSet =  CharacterSet.urlQueryAllowed
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        return escapedString ?? ""
    }
    
     func makeURL() -> URL? {
        
        let trimmed = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = URL(string: trimmed ?? "") else {
            return nil
        }
        return url
    }
    
    static func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        
		let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: String.CompareOptions.literal, range: nil)
    }
    static func widthForText(_ text: String, font: UIFont, height: CGFloat) -> CGFloat {
        
		let rect = NSString(string: text).boundingRect(with: CGSize(width:  CGFloat(MAXFLOAT), height:height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    

    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined(separator: "")
    }
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func removeHtmlFromString() -> String {
        
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
     static func nullCheck(string: String?) -> String {
        
        if string == nil {
            return ""
        } else {
            return string!
        }
    }
    
     func removeStringTill(occurence:String) -> String  {
        if let range = self.range(of: occurence) {
            let secondPart = self[range.upperBound...]
            NSLog("\(secondPart)")
            return String(secondPart)
        }
        return self
    }
    
   
 
    
    /// To Show the Date in String format
     func convertToShowFormatDate(dateFormatForInput inputformat: String, dateFormatForOutput outformat: String) -> String {
         let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = inputformat //Your date format
         let serverDate: Date = dateFormatterDate.date(from: self)! //according to date format your date string
         let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = outformat //Your New Date format as per requirement change it own
        let newDate: String = dateFormatterString.string(from: serverDate) //pass Date here
        NSLog(newDate) // New formatted Date string
        
        return newDate
    }
    
     func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
	
	func isValidEmail() -> Bool
	{
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: self.trimString())
	}
    
    func isValidPhone() -> Bool {
         let phoneRegex = "^[0-9]{6,14}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: self)
        return valid
    }
    
    
	func isValidPassword() -> Bool
	{
		//let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
		let regularExpression = "(?=.*?[#?!@$%^&*-]).{8,}$"
		let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
		let result=passwordValidation.evaluate(with: self)
		return result
	}
	func trimString() -> String{
		
		return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
	}
	
	func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
		let fontSize = UIFont.systemFontSize
		let attrs = [
			NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
			NSAttributedString.Key.foregroundColor: UIColor.black
		]
		let nonBoldAttribute = [
			NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
			]
		let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
		if let range = nonBoldRange {
			attrStr.setAttributes(nonBoldAttribute, range: range)
		}
		return attrStr
	}
	
	func nsRange(from range: Range<String.Index>) -> NSRange?
	{
		let utf16view = self.utf16
		if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
			return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
		}
		return nil
	}
	
	
	//MARK:- Date Calculation method
	func changeDate(mydate:String) -> String
	{
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = DateFormatter.Style.long
		dateFormatter.dateFormat = "dd-MMM-yyyy"
		let convertedDate = dateFormatter.date(from: mydate)
		dateFormatter.dateFormat = "dd-MMM-yyyy"
		let date = dateFormatter.string(from: convertedDate!)
		return date
	}
	 
	 
    
  
	// MARK:- String class extension for capitalizing first character
	
	func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
		let lang="en"//AppManager.getLanguageCodeForApp()
		if let path = Bundle.main.path(forResource: lang, ofType: "lproj"),let bundle = Bundle(path: path){
			return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: "**\(self)**", comment: "")
		}
		return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
	}
    
 
  /*  func upperCase() -> String {
        var str = ""
        if self.trimString().count ==  0 {return ""}
        let arr = self.components(separatedBy: " ")
        for letter in arr {
         str = str.appending("\(letter.upperCase())")
        }
        return str
    }*/
    
    func verifyUrl () -> Bool {
        if let encodedString  = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedString) {
            print(url) //
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    
    func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        if segments.count > 1 {
            return decodeJWTPart(segments[1]) ?? [:]
        }
        else{
            return [:]
        }
       
    }
    
    func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
            let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
        }
        return payload
   
}

}
