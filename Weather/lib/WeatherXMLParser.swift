import Foundation

class WeatherXMLParser:NSObject,XMLParserDelegate {
    private(set) public var forcasts: [Forcast] = []
    private var elementName: String = ""//name of each element name at variouse stages in the xml hierarchy
    /**
     * PARAM: url: API url to xml to be parsed
     * EXAMPLE URL: "https://api.met.no/weatherapi/locationforecast/1.9/?lat=59.91&lon=10.75"
     */
    func initiate(url:String){
//      let url:String = "https://api.met.no/weatherapi/locationforecast/1.9/?lat=59.91&lon=10.75"
        if let path =  URL.init(string: url){//{//Bundle.main.url(forResource: "met_5", withExtension: "xml")
            if let parser = XMLParser(contentsOf: path) {//gets the content and creates the Parser instance
                parser.delegate = self//set this class as the Parsers delegate
                let success:Bool = parser.parse()//initiates the parsing
                if success {
                    print("success")
                } else {
                    print("parse failure!")
                }
            }
        }
    }
    /**
     * Temp variables for the parser
     */
    struct Vars{
        var from:String = ""
        var to:String = ""
        var temperature:String?
        var symbol:String?
    }
    var vars:Vars = .init(from: "", to: "", temperature: nil, symbol: nil)
    /**
     * At the begining of an element
     */
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.elementName = elementName
        if elementName == "time" {
            vars.from = attributeDict["from"] ?? ""
            vars.to =  attributeDict["to"] ?? ""
            vars.symbol = nil//reset
            vars.temperature = nil//reset
        } else if elementName == "symbol" {
            vars.symbol =  attributeDict["number"]//use id for the weatherTypeName
        } else if elementName == "temperature" {
            vars.temperature =  attributeDict["value"]
        }
    }
    /**
     * At the end of an element
     */
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "time" {//when a book element completes parsing. Use the temp data and populate the Book struct, then append that book struct
            let forcast = Forcast.init(from: vars.from, to: vars.to, symbol:vars.symbol,temperature: vars.temperature)
            forcasts.append(forcast)
        }
    }
}
/**
 * Used as a store for each Forcast item in the XML
 */
struct Forcast{
    let from:String
    let to:String
    let symbol:String?
    let temperature:String?
}

