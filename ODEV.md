GÖREV 1: Mobil Akış Şeması (Flowchart) veya Sözde kod

GÖREV 2: REST API Uç Noktası (Endpoint) & JSON Tasarımı (25 Puan)

1. Sipariş Oluşturma Endpoint'i:
İSTEK
Post/api/v1/siparisler HTTP/1.1
Content-Type: application/json
Authorization: Bearer <token>
User-Agent:KodustaMobile/1.0.0(İphone17.,1;İOS 19.0)
{
“kahveAdi”:”Americano”,
“kahveBoyutu”:”Orta”,
"adet":1,
"tutar":250
}

CEVAP: sİPARİŞ BAŞARIYLA OLUŞTURULDU
HTTP/1.1 201 Created 
Date:Wed,15.Sep.202614:12:00 GMT
Content-Type:application/json

CEVAP:KULLANICI GİRİŞ YAPMAMIŞ
HTTP/1.1  401 Unauthorized
Date:Wed,15.Sep.202614:12:00 GMT
Content-Type:application/json

2. Cüzdan Bakiye Sorgulama Endpoint'i:
İSTEK
GET /api/v1/kullanici/bakiye HTTP/1.1

CEVAP
HTTP/1.1  200 OK
Date:Wed,15.Sep.202614:12:00 GMT
Content-Type:application/json
{
    "bakiye": 185.50,
    "para_birimi": "TRY"
}


CEVAP
HTTP/1.1  500 Internal Server Error
Date:Wed,15.Sep.202614:12:00 GMT
Content-Type:application/json

MÜLAKAT SORUSU CEVAP : GET idempotenttir, çünkü aynı istek birden fazla kez gönderildiğinde sistemin durumunu değiştirmez.
POST idempotent değildir, çünkü aynı istek tekrarlandığında yeni kayıtlar veya tekrarlanan işlemler oluşturabilir.