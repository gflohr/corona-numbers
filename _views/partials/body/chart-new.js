(function () {
	'use strict'

	feather.replace()

[% USE q = Qgoda %]
[% USE gtx = Gettext(config.local.textdomain) %]

	var color = '#ff6a6a';

	// Graphs
	var ctx = document.getElementById('chartNewCases')
	// eslint-disable-next-line no-unused-vars
	var chartNewCases = new Chart(ctx, {
	  type: 'bar',
	  data: {
		labels: [
			[% FOREACH record IN asset.data %]
				"[% q.strftime(gtx.gettext('%x'), record.timestamp, asset.lingua) %]",
			[% END %]
		],
		datasets: [
			{
				data: [
				[% FOREACH record IN asset.data %]
					[% record.new %],
				[% END %]
				],
				lineTension: 0,
				backgroundColor: color,
				borderColor: color,
				borderWidth: 4,
				pointBackgroundColor: color
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
		  display: false
		}
	  }
	})
  }())
  