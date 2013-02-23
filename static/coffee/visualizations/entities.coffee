#=============================================================================
#
#Main visualization
#
#=============================================================================
socket = io.connect('http://localhost:1337')
socket.on('returnedLogData', (data)->
    console.log(data)
    drawChart(data)
)

#----------------------------------------
#Draw chart function
#----------------------------------------
drawChart = (data)->
    svgEl = d3.select('#chart-main')
    svgEl.select('*').remove()
    
    width = svgEl.attr('width')
    height = svgEl.attr('height')
    
    dataMin = d3.min(data, (d)->
        return 0
    )
    dataMax = d3.max(data, (d)->
        return d.entityCounts.all
    )

    #SCALES
    #------------------------------------
    xScale = d3.scale.linear()
        .domain([0,data.length])
        .rangeRound([0, width])
        
    yScale = d3.scale.linear()
        .domain([dataMin, dataMax])
        .range([height, 0])
        
    #Line
    #------------------------------------
    lines = {}
    for type in ['all', 'human', 'zombie']
        do(type)->
            lines[type] = d3.svg.line()
                .x((d,i)->
                    return xScale(i)
                ).y((d)->
                    return yScale(d.entityCounts[type])
                ).interpolate('linear')

    #Add to chart
    #------------------------------------
    lineGroups = svgEl.append('svg:g')
    
    #ALL entities
    lineGroups.append('svg:path')
        .data([data])
        .attr({
            d: lines.all
        })
        .style({
            fill: 'none'
            stroke: '#343434'
        })

    #Human entities
    lineGroups.append('svg:path')
        .data([data])
        .attr({
            d: lines.human
        })
        .style({
            fill: 'none'
            stroke: '#336699'
        })
        
    #Zombie entities
    lineGroups.append('svg:path')
        .data([data])
        .attr({
            d: lines.zombie
        })
        .style({
            fill: 'none'
            stroke: '#dd2222'
        })
        
    return true
    
#=============================================================================
#Setup 
#=============================================================================
socket.emit('getLogData')
