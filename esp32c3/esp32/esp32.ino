#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

const char* ssid = "GO HOME";
const char* password = "password";


// URL đầy đủ phải bao gồm: /rest/v1/ + tên_bảng + tham số lọc
const char* supabase_url = "supabase_url";
const char* supabase_key = "supabase_API_NON_KEY";


#define LED_PIN 8 

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);

  WiFi.begin(ssid, password);
  Serial.print("Dang ket noi WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nDa ket noi WiFi!");
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    
    // Cấu hình request
    http.begin(supabase_url);
    http.addHeader("apikey", supabase_key);
    http.addHeader("Authorization", String("Bearer ") + supabase_key);
    http.addHeader("Content-Type", "application/json");

    // Gửi lệnh GET
    int httpCode = http.GET();

    if (httpCode > 0) {
      String payload = http.getString();
      
  
      Serial.print("Du lieu nhan duoc: ");
      Serial.println(payload);
      // -----------------------------

      DynamicJsonDocument doc(1024);
      deserializeJson(doc, payload);
      
      bool isOn = doc[0]["is_on"]; // Lấy trạng thái

      if (isOn) {
 
        digitalWrite(LED_PIN, HIGH); // Sửa thành HIGH để đèn sáng
        Serial.println("Den dang BAT");
      } else {
   
        digitalWrite(LED_PIN, LOW);  // Sửa thành LOW để đèn tắt
        Serial.println("Den dang TAT");
      }
    } else {
      Serial.println("Loi HTTP");
    }
    http.end();
  }
  
  delay(2000); // Kiểm tra mỗi 2 giây
}