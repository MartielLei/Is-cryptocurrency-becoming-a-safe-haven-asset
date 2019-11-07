Divided into three major sections
First, the gold market
(1) SPTAUUSDOZ.IDC: International gold spot price, named: SpotInternationalGold (SIG)
(2) GC.CMX: International gold futures price, named: FuturesInternationalGold(FIG)
(3) AU.SHF: Domestic gold futures price, named: FuturesDomesticGold (FDG)
(4) AU9999.SGE: Domestic gold spot price, named: SpotDomesticGold (SDG)

Second, the stock market
(1) SPX.GI: Standard & Poor's 500 (SP500), named: SP500
(2) IXIC.GI: Nasdaq index, named: NASDAQ
(3)000300.SH: Shanghai and Shenzhen 300, named SH300
(4) HSI.HI: Hong Kong Hang Seng Index, named HSI
(5) FTSE.GI: London Financial Times 100 Index, named: FTSE
(6) FCHI.GI: Paris, France, CAC40 index, named: FCHI
(7) GDAXI.GI: German DAX30 index, named: GDAXI
(8) N225.GI: Nikkei 225, named: N225

Third, the exchange rate market
(1) USDCNH.FX: USD/RMB, named UCE
(2) USDJPY.FX: USD/JPY, named UJE
(3) EURUSD.FX: EUR/USD, named EUE
(4) GBPUSD.FX: GBP/USD, named GUE
(5) USDCAD.FX: US dollar against Canadian dollar, named UDE
(6) USDCNH.FX, offshore RMB market, named CNH
(7) USDCHF.FX, USD/Fran, named: UFE
(8) USDX.FX: US dollar index, named USDX



Data preprocessing:
(1) Linear interpolation complement missing values
(2) Based on the WIND data, 1157 data are screened according to the date, covering 201703-201909
(3) Estimate the daily frequency volatility according to the lowest/highest price, and annualize
