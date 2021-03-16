(function () {
	'use strict'

	feather.replace()

[% USE q = Qgoda %]
[% USE gtx = Gettext(config.po.textdomain, asset.lingua) %]

	var options = {
		displayLegend: true,
	};

	if (window.screen.availWidth < 600) {
		options.displayLegend = false;
	}

	// Graphs
	var ctx = document.getElementById('chartIncidence')
	// eslint-disable-next-line no-unused-vars
	var chartIncidence = new Chart(ctx, {
	  type: 'line',
	  data: {
		labels: [
			[% FOREACH record IN asset.data %]
				"[% q.strftime(gtx.gettext('%x'), record.timestamp, asset.lingua) %]",
			[% END %]
		],
		datasets: [
			{
				label: "[% gtx.gettext('14-day Incidence') %]",
				data: [
				[% FOREACH record IN asset.data %]
					[% record.incidence14 %],
				[% END %]
				],
				lineTension: 0,
				backgroundColor: 'transparent',
				borderColor: '#f04848',
				borderWidth: 2,
				pointBackgroundColor: '#fo4848'
			},
			{
				label: "[% gtx.gettext('7-day Incidence') %]",
				data: [
				[% FOREACH record IN asset.data %]
					[% record.incidence7 %],
				[% END %]
				],
				lineTension: 0,
				backgroundColor: 'transparent',
				borderColor: '#aa0008',
				borderWidth: 2,
				pointBackgroundColor: '#aa0008'
			}
		]
	  },
	  options: {
		scales: {
		  yAxes: [{
			ticks: {
			  beginAtZero: true
			}
		  }]
		},
		legend: {
			display: options.displayLegend,
			position: 'bottom',
		}
	  }
	})
  }())
  