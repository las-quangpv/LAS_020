import Foundation

struct DataCommonModel {
    static let fizkey = "fizaafiozpen"
    static let timekey = "timezchanged"
    
    fileprivate var time: Date?
    fileprivate var extra: String? {
        didSet {
            if let json = extra?.toJson {
                extraJSON = json
            } else {
                extraJSON = nil
            }
        }
    }
    fileprivate var extraJSON: MoDictionary?
    
    fileprivate var _allAds: [AdsObject] = adsesDefault
    fileprivate var adsActtive: [AdsObject] {
        return _allAds.sorted(by: { ($0.sort ?? 0) < ($1.sort ?? 0) })
    }
    
    public var openRatingView: Bool {
        guard let _time = time,
              let _fiozpen = UserDefaults.standard.object(forKey: Self.fizkey) as? Date
        else {
            return false
        }
        
        if UserDefaults.standard.bool(forKey: Self.timekey) {
            return false
        }
        
        let xTime: Int? = self.extraFind("in_time")
        if let _xTime = xTime {
            return Date().timeIntervalSince1970 >= _fiozpen.timeIntervalSince1970 + TimeInterval(_xTime)
        }
        else {
            return _time.timeIntervalSince1970 >= _fiozpen.timeIntervalSince1970
        }
    }
    
    public var isRating: Bool = false
    
    // MARK: - static instance
    public static var shared = DataCommonModel()
    
    // MARK: - keys admob
    @LocalStorage(key: "admob_banner", value: "ca-app-pub-2299291161271404/4010789391")
    public var admob_banner: String
    
    @LocalStorage(key: "admob_inter", value: "ca-app-pub-2299291161271404/5223760725")
    public var admob_inter: String
    
    @LocalStorage(key: "admob_inter_splash", value: "ca-app-pub-2299291161271404/9194795328")
    public var admob_inter_splash: String
    
    @LocalStorage(key: "admob_reward", value: "ca-app-pub-2299291161271404/1384626058")
    public var admob_reward: String
    
    @LocalStorage(key: "admob_reward_interstitial", value: "ca-app-pub-2299291161271404/8337047216")
    public var admob_reward_interstitial: String
    
    @LocalStorage(key: "admob_small_native", value: "ca-app-pub-2299291161271404/2178832978")
    public var admob_small_native: String
    
    @LocalStorage(key: "admob_medium_native", value: "ca-app-pub-2299291161271404/9865751302")
    public var admob_medium_native: String
    
    @LocalStorage(key: "admob_manual_native", value: "ca-app-pub-2299291161271404/8552669634")
    public var admob_manual_native: String
    
    @LocalStorage(key: "admob_appopen", value: "ca-app-pub-2299291161271404/7239587968")
    public var admob_appopen: String
    
    
    // MARK: - keys applovin
    @LocalStorage(key: "applovin_banner", value: "ea06a84d2804baf4")
    public var applovin_banner: String
    
    @LocalStorage(key: "applovin_inter", value: "b089497c06db8034")
    public var applovin_inter: String
    
    @LocalStorage(key: "applovin_inter_splash", value: "bc75e694a046dea9")
    public var applovin_inter_splash: String
    
    @LocalStorage(key: "applovin_reward", value: "5fac44d4428088fd")
    public var applovin_reward: String
    
    @LocalStorage(key: "applovin_small_native", value: "8b51810dd7605e23")
    public var applovin_small_native: String
    
    @LocalStorage(key: "applovin_medium_native", value: "24714d970355d936")
    public var applovin_medium_native: String
    
    @LocalStorage(key: "applovin_manual_native", value: "546b9b67dfa24ba1")
    public var applovin_manual_native: String
    
    @LocalStorage(key: "applovin_appopen", value: "420efa544d8bec70")
    public var applovin_appopen: String
    
    // ?
    @LocalStorage(key: "applovin_id", value: "")
    public var applovin_id: String
}

extension DataCommonModel {
    public func extraFind<T>(_ key: String) -> T? {
        return (extraJSON ?? [:])[key] as? T
    }
    
    public func adsAvailableFor(_ name: AdsName) -> AdsObject? {
        return self.adsActtive.filter({ $0.name == .admob }).first
    }
    
    public func adsAvailableFor(_ unit: AdsUnit) -> [AdsObject] {
        return self.adsActtive.filter({ $0.adUnits.contains(unit.rawValue) }).sorted(by: { ($0.sort ?? 0) < ($1.sort ?? 0) })
    }
    
    public func isAvailable(_ name: AdsName, _ unit: AdsUnit) -> Bool {
        return self.adsAvailableFor(unit).contains(where: { $0.name == name })
    }
    
    public mutating func readData() {
        let data = NetworksService.shared.dataCommonSaved()
        
        if let timestamp = data["time"] as? TimeInterval {
            self.time = Date(timeIntervalSince1970: timestamp)
        }
        if let listAds = data["adses"] as? [MoDictionary] {
            self._allAds.removeAll()
            for dic in listAds {
                if let name = dic["name"] as? String, let type = AdsName(rawValue: name) {
                    let m = AdsObject(name: type, sort: dic["sort"] as? Int, adUnits: (dic["adUnits"] as? [String]) ?? [])
                    self._allAds.append(m)
                }
            }
        }
        
        self.isRating = (data["isRating"] as? Bool) ?? false
        self.extra = data["extra"] as? String
    }
    
}
