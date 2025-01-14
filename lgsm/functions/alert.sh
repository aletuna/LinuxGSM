#!/bin/bash
# LinuxGSM alert.sh function
# Author: Daniel Gibbs
# Website: https://linuxgsm.com
# Description: Overall function for managing alerts.

local commandname="ALERT"
local commandaction="Alert"

fn_alert_log(){
	info_distro.sh
	info_config.sh
	info_messages.sh
	if [ -f "${alertlog}" ]; then
		rm "${alertlog}"
	fi

	{
		fn_info_message_head
		fn_info_message_distro
		fn_info_message_server_resource
		fn_info_message_gameserver_resource
		fn_info_message_gameserver
		fn_info_logs
	} | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"| tee -a "${alertlog}" > /dev/null 2>&1
}

fn_alert_test(){
	fn_script_log_info "Sending test alert"
	alertsubject="Alert - ${servicename} - Test"
	alertemoji="🚧"
	alertsound="1"
	alerturl="not enabled"
	alertbody="Testing LinuxGSM Alert. No action to be taken."
}

fn_alert_restart(){
	fn_script_log_info "Sending alert: Restarted: ${executable} not running"
	alertsubject="Alert - ${servicename} - Restarted"
	alertemoji="🚨"
	alertsound="2"
	alerturl="not enabled"
	alertbody="${servicename} ${executable} not running"
}

fn_alert_restart_query(){
	fn_script_log_info "Sending alert: Restarted: ${servicename}"
	alertsubject="Alert - ${servicename} - Restarted"
	alertemoji="🚨"
	alertsound="2"
	alerturl="not enabled"
	alertbody="Unable to query: ${servicename}"
}

fn_alert_update(){
	fn_script_log_info "Sending alert: Updated"
	alertsubject="Alert - ${servicename} - Updated"
	alertemoji="🎮"
	alertsound="1"
	alerturl="not enabled"
	alertbody="${gamename} received update"
}

fn_alert_permissions(){
	fn_script_log_info "Sending alert: Permissions error"
	alertsubject="Alert - ${servicename}: Permissions error"
	alertemoji="❗"
	alertsound="2"
	alerturl="not enabled"
	alertbody="${servicename} has permissions issues"
}

fn_alert_config(){
	fn_script_log_info "Sending alert: New _default.cfg"
	alertsubject="Alert - ${servicename} - New _default.cfg"
	alertemoji="🎮"
	alertsound="1"
	alerturl="not enabled"
	alertbody="${servicename} has recieved a new _default.cfg. Check file for changes."
}

fn_alert_command_restart(){
	fn_script_log_info "Sending alert: Restarted: ${servicename}"
	alert_slack="Alert - ${servicename} - Restart By Admin"
	alertemoji="↪️"
	alertsound="2"
	alerturl="not enabled"
	alertbody="${alertonrestartmessage}"
}

fn_alert_command_install(){
	fn_script_log_info "Sending alert: Install triggered: ${servicename}"
	alert_slack="Alert - ${servicename} - Install requested By Admin"
	alertemoji="⚡"
	alertsound="2"
	alerturl="not enabled"
	alertbody="Install started"
}

fn_alert_command_mod_install(){
	fn_script_log_info "Sending alert: Mod install: ${servicename}"
	alert_slack="Alert - ${servicename} - Mod install requested By Admin"
	alertemoji="⚡"
	alertsound="2"
	alerturl="not enabled"
	alertbody="Mod install started"
}

fn_alert_command_mod_update(){
	fn_script_log_info "Sending alert: Mod update: ${servicename}"
	alert_slack="Alert - ${servicename} - Mod update requested By Admin"
	alertemoji="⚡"
	alertsound="2"
	alerturl="not enabled"
	alertbody="Mod update started"
}

fn_alert_command_start(){
	fn_script_log_info "Sending alert: Start: ${servicename}"
	alert_slack="Alert - ${servicename} - Start requested By Admin"
	alertemoji="⚡"
	alertsound="2"
	alerturl="not enabled"
	alertbody="Start started"
}

fn_alert_command_stop(){
	fn_script_log_info "Sending alert: Stop: ${servicename}"
	alert_slack="Alert - ${servicename} - Stop requested By Admin"
	alertemoji="⚡"
	alertsound="2"
	alerturl="not enabled"
	alertbody="Stop started"
}

fn_alert_command_update(){
	fn_script_log_info "Sending alert: Server Update: ${servicename}"
	alert_slack="Alert - ${servicename} - Server Update requested By Admin"
	alertemoji="⚡"
	alertsound="2"
	alerturl="not enabled"
	alertbody="Server Update started"
}

fn_alert_command_validate(){
	fn_script_log_info "Sending alert: Server validation: ${servicename}"
	alert_slack="Alert - ${servicename} - Server validation requested By Admin"
	alertemoji="⚡"
	alertsound="2"
	alerturl="not enabled"
	alertbody="Server validation started"
}


if [ "${alert}" == "permissions" ]; then
	fn_alert_permissions
elif [ "${alert}" == "restart" ]; then
	fn_alert_restart
elif [ "${alert}" == "restartquery" ]; then
	fn_alert_restart_query
elif [ "${alert}" == "test" ]; then
	fn_alert_test
elif [ "${alert}" == "update" ]; then
	fn_alert_update
elif [ "${alert}" == "config" ]; then
	fn_alert_config
elif [ "${alert}" == "commandrestart" ]; then
	fn_alert_command_restart
elif [ "${alert}" == "commandinstall" ]; then
	fn_alert_command_restart
elif [ "${alert}" == "commandmodinstall" ]; then
	fn_alert_command_restart
elif [ "${alert}" == "commandmodupdate" ]; then
	fn_alert_command_restart
elif [ "${alert}" == "commandstart" ]; then
	fn_alert_command_restart
elif [ "${alert}" == "commandstop" ]; then
	fn_alert_command_restart
elif [ "${alert}" == "commandupdate" ]; then
	fn_alert_command_restart
elif [ "${alert}" == "commandvalidate" ]; then
	fn_alert_command_restart
fi

# Generate alert log.
fn_alert_log

# Generates the more info link.
if [ "${postalert}" == "on" ]&&[ -n "${postalert}" ]; then
	alertflag=1
	command_postdetails.sh
elif [ "${postalert}" != "on" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_warn_nl "More Info not enabled"
	fn_script_log_warn "More Info alerts not enabled"
elif [ -z "${posttarget}" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_error_nl "posttarget not set"
	fn_script_error "posttarget not set"
elif [ -z "${postdays}" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_error_nl "postdays not set"
	fn_script_error "postdays not set"
fi

if [ "${discordalert}" == "on" ]&&[ -n "${discordalert}" ]; then
	alert_discord.sh
elif [ "${discordalert}" != "on" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_warn_nl "Discord alerts not enabled"
	fn_script_log_warn "Discord alerts not enabled"
elif [ -z "${discordtoken}" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_error_nl "Discord token not set"
	echo -e "	* https://docs.linuxgsm.com/alerts/discord"
	fn_script_error "Discord token not set"
fi

if [ "${emailalert}" == "on" ]&&[ -n "${email}" ]; then
	alert_email.sh
elif [ "${emailalert}" != "on" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_warn_nl "Email alerts not enabled"
	fn_script_log_warn "Email alerts not enabled"
elif [ -z "${email}" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_error_nl "Email not set"
	fn_script_log_error "Email not set"
fi

if [ "${iftttalert}" == "on" ]&&[ -n "${iftttalert}" ]; then
	alert_ifttt.sh
elif [ "${iftttalert}" != "on" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_warn_nl "IFTTT alerts not enabled"
	fn_script_log_warn "IFTTT alerts not enabled"
elif [ -z "${ifttttoken}" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_error_nl "IFTTT token not set"
	echo -e "	* https://docs.linuxgsm.com/alerts/ifttt"
	fn_script_error "IFTTT token not set"
fi

if [ "${mailgunalert}" == "on" ]&&[ -n "${mailgunalert}" ]; then
	alert_mailgun.sh
elif [ "${mailgunalert}" != "on" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_warn_nl "Mailgun alerts not enabled"
	fn_script_log_warn "Mailgun alerts not enabled"
elif [ -z "${mailguntoken}" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_error_nl "Mailgun token not set"
	echo -e "	* https://docs.linuxgsm.com/alerts/mailgun"
	fn_script_error "Mailgun token not set"
fi

if [ "${pushbulletalert}" == "on" ]&&[ -n "${pushbullettoken}" ]; then
	alert_pushbullet.sh
elif [ "${pushbulletalert}" != "on" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_warn_nl "Pushbullet alerts not enabled"
	fn_script_log_warn "Pushbullet alerts not enabled"
elif [ -z "${pushbullettoken}" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_error_nl "Pushbullet token not set"
	echo -e "	* https://docs.linuxgsm.com/alerts/pushbullet"
	fn_script_error "Pushbullet token not set"
fi

if [ "${pushoveralert}" == "on" ]&&[ -n "${pushoveralert}" ]; then
	alert_pushover.sh
elif [ "${pushoveralert}" != "on" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_warn_nl "Pushover alerts not enabled"
	fn_script_log_warn "Pushover alerts not enabled"
elif [ -z "${pushovertoken}" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_error_nl "Pushover token not set"
	echo -e "	* https://docs.linuxgsm.com/alerts/pushover"
	fn_script_error "Pushover token not set"
fi

if [ "${telegramalert}" == "on" ]&&[ -n "${telegramtoken}" ]; then
	alert_telegram.sh
elif [ "${telegramalert}" != "on" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_warn_nl "Telegram Messages not enabled"
	fn_script_log_warn "Telegram Messages not enabled"
elif [ -z "${telegramtoken}" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_error_nl "Telegram token not set."
	echo -e "	* https://docs.linuxgsm.com/alerts/telegram"
	fn_script_error "Telegram token not set."
elif [ -z "${telegramchatid}" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_error_nl "Telegram chat id not set."
	echo -e "	* https://docs.linuxgsm.com/alerts/telegram"
	fn_script_error "Telegram chat id not set."
fi

if [ "${slackalert}" == "on" ]&&[ -n "${slackalert}" ]; then
	alert_slack.sh
elif [ "${slackalert}" != "on" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_warn_nl "Slack alerts not enabled"
	fn_script_log_warn "Slack alerts not enabled"
elif [ -z "${slacktoken}" ]&&[ "${function_selfname}" == "command_test_alert.sh" ]; then
	fn_print_error_nl "Slack token not set"
	echo -e "	* https://docs.linuxgsm.com/alerts/slack"
	fn_script_error "Slack token not set"
fi
