local mod = require 'core/mods'

mod.hook.register('script_pre_init', 'begin ddm', function()
	hs_init()
	state.system_post_startup = true
  end)

function hs_init()
	audio.level_cut(1.0)
	audio.level_adc_cut(1)
	audio.level_eng_cut(1)
	
	-- 1
	softcut.level(1,1.0)
	softcut.level_slew_time(1,0)
	softcut.level_input_cut(1, 1, 1.0)
	softcut.level_input_cut(2, 1, 1.0)
	softcut.pan(1, 1)

	softcut.play(1, 1)
	softcut.rate(1, 1)
	softcut.rate_slew_time(1,0)
	softcut.loop_start(1, 1)
	softcut.loop_end(1, 1.5)
	softcut.loop(1, 1)
	softcut.fade_time(1, 0.1)
	softcut.rec(1, 1)
	softcut.rec_level(1, 1)
	softcut.pre_level(1, 0.75)
	softcut.position(1, 1)
	softcut.enable(1, 1)

	softcut.filter_dry(1, 0.125);
	softcut.filter_fc(1, 1200);
	softcut.filter_lp(1, 0);
	softcut.filter_bp(1, 1.0);
	softcut.filter_rq(1, 2.0);

	-- 2
	softcut.level(2,1.0)
	softcut.level_slew_time(2,0)
	softcut.level_input_cut(1, 2, 1.0)
	softcut.level_input_cut(2, 2, 1.0)
	softcut.pan(2, -1)

	softcut.play(2, 1)
	softcut.rate(2, 1)
	softcut.rate_slew_time(2,0.25)
	softcut.loop_start(2, 1)
	softcut.loop_end(2, 1.5)
	softcut.loop(2, 1)
	softcut.fade_time(2, 0.1)
	softcut.rec(2, 1)
	softcut.rec_level(2, 1)
	softcut.pre_level(2, 0.75)
	softcut.position(2, 1)
	softcut.enable(2, 1)

	softcut.filter_dry(2, 0);
	softcut.filter_fc(2, 1200);
	softcut.filter_lp(2, 0);
	softcut.filter_bp(2, 1.0);
	softcut.filter_rq(2, 2.0);

	params:add_group("DELAY",7)

	params:add{id="delay", name="level", type="control", 
	  controlspec=controlspec.new(0,1,'lin',0,0.5,""),
	  action=function(x) 
		  softcut.level(1,x) 
		  softcut.level(2,x) 
	  end
  }
  params:add{id="delay_cutoff", name="band center", type="control",
	  controlspec=controlspec.WIDEFREQ,
	  action=function(x)
		  softcut.filter_fc(1,x)
		  softcut.filter_fc(2,x)
	  end
  }
  params:add{id="delay_q", name="band width", type="control",
	  controlspec=controlspec.new(0.1,4.0,'lin',0.1,2,""),
	  action=function(x)
		  softcut.filter_rq(1,x)
		  softcut.filter_rq(2,x)
	  end
  }
	params:add{id="delay_rate", name="delay rate", type="control", 
	  controlspec=controlspec.new(0.1,2.0,'exp',0.01,1,""),
	  action=function(x)
		  softcut.rate(1,x-params:get('delay_skew')) 
		  softcut.rate(2,x+params:get('delay_skew'))
	  end
  }
  params:add{id="delay_skew", name="delay skew", type="control",
	  controlspec=controlspec.new(-1.0,1.0,'lin',0.01,0),
	  action=function(x)
		  softcut.rate(1,x+params:get('delay_rate'))
		  softcut.rate(2,x-params:get('delay_rate'))
	  end
  }
	params:add{id="delay_feedback", name="delay feedback", type="control", 
	  controlspec=controlspec.new(0,1.0,'lin',0,0.75,""),
	  action=function(x) 
		  softcut.pre_level(1,x) 
		  softcut.pre_level(2,x)
	  end
  }
	params:add{id="delay_width", name="delay width", type="control", 
	  controlspec=controlspec.new(0.0,1.0,'lin',0,0,""),
	  action=function(x) 
		  softcut.pan(1,-x) 
		  softcut.pan(1,x) 
	  end
  }
end
