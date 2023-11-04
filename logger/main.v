module logger

import log
import time

pub fn start() {
	// logs
	mut l := log.Log{}
	l.set_level(.info)
	l.set_full_logpath('./log_${time.now().custom_format('YYYY-MM-DD')}.log')
	l.log_to_console_too()
	l.debug('debug')
	l.info('info')
	l.warn('warn')
	l.error('error')
}

pub fn simple(level string, description string) {
	match level {
		'info' { log.info(description) }
		'warn' { log.warn(description) }
		'error' { log.error(description) }
		'fatal' { log.fatal(description) }
		else { log.debug(description) }
	}
}
