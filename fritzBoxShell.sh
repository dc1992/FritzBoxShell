if [ -z "$BoxUSER" ]; then
  echo "Error: BoxUSER is not set."
  exit 1
fi

if [ -z "$BoxPW" ]; then
  echo "Error: BoxPW is not set."
  exit 1
fi

#2G methods
WLAN_2G_ON() {
	location="/upnp/control/wlanconfig1"
	uri="urn:dslforum-org:service:WLANConfiguration:1"
	action='SetEnable'
	signal=1
	
	echo "Sending WLAN_2G ON signal";
	generic_state_switch;
}

WLAN_2G_OFF() {
	location="/upnp/control/wlanconfig1"
	uri="urn:dslforum-org:service:WLANConfiguration:1"
	action='SetEnable'
	signal=0

	echo "Sending WLAN_2G OFF signal";
	generic_state_switch;
}

WLAN_2G_STATE() {
	location="/upnp/control/wlanconfig1"
	uri="urn:dslforum-org:service:WLANConfiguration:1"
	action='GetInfo'

	generic_state;

	echo "2,4 Ghz Network $networkName is $state"
}

#5G methods
WLAN_5G_ON() {
	location="/upnp/control/wlanconfig2"
	uri="urn:dslforum-org:service:WLANConfiguration:2"
	action='SetEnable'
	signal=1
	
	echo "Sending WLAN_5G ON signal"; 
	generic_state_switch;
}

WLAN_5G_OFF() {
	location="/upnp/control/wlanconfig2"
	uri="urn:dslforum-org:service:WLANConfiguration:2"
	action='SetEnable'
	signal=0
	
	echo "Sending WLAN_5G OFF signal";
	generic_state_switch;
}

WLAN_5G_STATE() {
	location="/upnp/control/wlanconfig2"
	uri="urn:dslforum-org:service:WLANConfiguration:2"
	action='GetInfo'

	generic_state;

	echo "5 Ghz Network $networkName is $state"
}

#Utils
REBOOT() {
	location="/upnp/control/deviceconfig"
	uri="urn:dslforum-org:service:DeviceConfig:1"
	action='Reboot'

	echo "Sending Reboot command to Fritz!Box"; 
	curl -k -m 5 --anyauth -u "$BoxUSER:$BoxPW" "http://fritz.box:49000$location" -H 'Content-Type: text/xml; charset="utf-8"' -H "SoapAction:$uri#$action" -d "<?xml version='1.0' encoding='utf-8'?><s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'><s:Body><u:$action xmlns:u='$uri'></u:$action></s:Body></s:Envelope>" -s > /dev/null;
}

DISPLAY_ARGUMENTS() {
	echo "|--------------|------------|------------------------|"
	echo "| Action       | Parameter  | Description            |"
	echo "|--------------|------------|------------------------|"
	echo "| wifi         | on         | Switches ON WiFi       |"
	echo "| wifi         | off        | Switches OFF WiFi      |"
	echo "| wifi         | state      | Prints WiFi's state    |"
	echo "|--------------|------------|------------------------|"
	echo "| reboot       |            | Reboots your Fritz!Box |"
	echo "|--------------|------------|------------------------|"
	echo "| help         |            | Show this helper       |"
	echo "|--------------|------------|------------------------|"
	echo ""
}

#Private functions
generic_state_switch() {
	curl -k -m 5 --anyauth -u "$BoxUSER:$BoxPW" "http://fritz.box:49000$location" -H 'Content-Type: text/xml; charset="utf-8"' -H "SoapAction:$uri#$action" -d "<?xml version='1.0' encoding='utf-8'?><s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'><s:Body><u:$action xmlns:u='$uri'><NewEnable>$signal</NewEnable></u:$action></s:Body></s:Envelope>" -s > /dev/null; # Changing the state of the WIFI
}

generic_state() {
	stateResponse=$(curl -s -k -m 5 --anyauth -u "$BoxUSER:$BoxPW" "http://fritz.box:49000$location" -H 'Content-Type: text/xml; charset="utf-8"' -H "SoapAction:$uri#$action" -d "<?xml version='1.0' encoding='utf-8'?><s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'><s:Body><u:$action xmlns:u='$uri'></u:$action></s:Body></s:Envelope>" | grep NewEnable | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
	networkName=$(curl -s -k -m 5 --anyauth -u "$BoxUSER:$BoxPW" "http://fritz.box:49000$location" -H 'Content-Type: text/xml; charset="utf-8"' -H "SoapAction:$uri#$action" -d "<?xml version='1.0' encoding='utf-8'?><s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'><s:Body><u:$action xmlns:u='$uri'></u:$action></s:Body></s:Envelope>" | grep NewSSID | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
	case "$stateResponse" in
		0) state='off' ;;
		1) state='on' ;;
		*) state='unknown' ;;
	esac
}

# Run
dir=$(dirname "$0")

if [ $# -eq 0 ]
then
  DISPLAY_ARGUMENTS
else
	if [ "$1" = "wifi" ]; then
		if [ "$2" = "on" ]; then 
			WLAN_2G_ON;
			WLAN_2G_STATE;
			WLAN_5G_ON;
			WLAN_5G_STATE;
		elif [ "$2" = "off" ]; then 
			WLAN_2G_OFF;
			WLAN_2G_STATE;
			WLAN_5G_OFF;
			WLAN_5G_STATE;
		elif [ "$2" = "state" ]; then 
			WLAN_2G_STATE;
			WLAN_5G_STATE;
		else 
			echo $"Invalid Action and/or parameter. Possible combinations:\n"
			DISPLAY_ARGUMENTS;
		fi
	elif [ "$1" = "reboot" ]; then
		REBOOT;
	elif [ "$1" = "help" ]; then
		DISPLAY_ARGUMENTS;
	else
		echo $"Invalid Action and/or parameter. Possible combinations:\n" 
		DISPLAY_ARGUMENTS;
	fi
fi
