import android.net.wifi.WifiManager;
import android.text.format.Formatter;

String IP;

void setup(){
  background(0);
  WifiManager wim= (WifiManager) getSystemService(WIFI_SERVICE);
  IP = Formatter.formatIpAddress(wim.getConnectionInfo().getIpAddress());
  textSize(40);
  text("IP: "+ IP,10,100);
}

