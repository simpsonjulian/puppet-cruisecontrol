class cruisecontrol {

	remotefile { "/usr/local/sbin/iptables.sh":
				mode=>0755,
				source => "/usr/local/sbin/iptables.sh"
	}

  exec { "apply firewall ruleset":
	     command => "/usr/local/sbin/iptables.sh",
			 require => File["/usr/local/sbin/iptables.sh"]
	}

	package {  
		"cruisecontrol": ensure => installed;
		"sun-java5-jdk": ensure => installed;
		"rake": ensure => installed;
		"xsltproc": ensure => installed;
		"tetex-bin": ensure => installed;
		"tetex-extra": ensure => installed;
		"ant": ensure => installed;
		"lsb-rpm": ensure => installed;
		"rpm": ensure => installed;
		"maruku": ensure => installed, provider => gem;
	}
	
	service { 
		"cruisecontrol": enable => false, ensure => stopped
	} 

	remotefile { "/etc/cruisecontrol/cruisecontrol.xml":
	    mode => 0444,
	    owner => 'cruise',
	    group => 'cruise', 
	    source => "/etc/cruisecontrol/cruisecontrol.xml",
	}
	
	file { 
		"/data/cruise": ensure => 'directory', recurse => 'true';
		"/var/spool/cruisecontrol/logs": mode => 1777;
		"/data/cruise/root": ensure => 'directory', recurse => 'true', owner => 'cruise', group => 'cruise';
	}
	
	
	group {"cruise":
		ensure => present,
		gid => 1001
	}
	
	user {"cruise": 
		ensure => present,
		uid => 1001,
		require => Group["cruise"]
	}
	
	
}
