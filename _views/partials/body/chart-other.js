(function () {
	'use strict'

	feather.replace()

[% USE q = Qgoda %]
[% USE gtx = Gettext(config.local.textdomain) %]

	// Graphs
	var ctx = document.getElementById('chartOther')
	// eslint-disable-next-line no-unused-vars
	var chartOther = new Chart(ctx, {
	  type: 'line',
	  data: {
		labels: [
			[% FOREACH record IN asset.data %]
				"[% q.strftime(gtx.gettext('%x'), record.timestamp, asset.lingua) %]",
			[% END %]
		],
		datasets: [
			{
				label: "[% gtx.gettext('Confirmed') %]",
				data: [
				[% FOREACH record IN asset.data %]
					[% record.confirmed %],
				[% END %]
				],
				lineTension: 0,
				backgroundColor: 'transparent',
				borderColor: '#aa0008',
				borderWidth: 2,
				pointBackgroundColor: '#aa0008'
			},
			{
				label: "[% gtx.gettext('New Confirmed') %]",
				data: [
				[% FOREACH record IN asset.data %]
					[% record.new %],
				[% END %]
				],
				lineTension: 0,
				backgroundColor: 'transparent',
				borderColor: '#f04848',
				borderWidth: 2,
				pointBackgroundColor: '#f04848'
			},
			{
				label: "[% gtx.gettext('Recovered') %]",
				data: [
				[% FOREACH record IN asset.data %]
					[% record.recovered %],
				[% END %]
				],
				lineTension: 0,
				backgroundColor: 'transparent',
				borderColor: '#4486cc',
				borderWidth: 2,
				pointBackgroundColor: '#4486cc'
			},
			{
				label: "[% gtx.gettext('Deaths') %]",
				data: [
				[% FOREACH record IN asset.data %]
					[% record.deaths %],
				[% END %]
				],
				lineTension: 0,
				backgroundColor: 'transparent',
				borderColor: '#777777',
				borderWidth: 2,
				pointBackgroundColor: '#777777'
			},
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
			display: true
		}
	  }
	})
  }())
  