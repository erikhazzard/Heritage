#=============================================================================
#
#Main visualization
#
#=============================================================================
socket = io.connect('http://localhost:1337')
socket.on('returnedLogData', (data)->
    drawChart(data)
)

#----------------------------------------
#Draw chart function
#----------------------------------------
drawChart = (data)->
    svgEl = d3.select('#chart-performance')
    svgEl.select('*').remove()
    
    width = svgEl.attr('width')
    height = svgEl.attr('height')
    
    dataMin = d3.min(data, (d)->
        return 0
    )
    dataMax = d3.max(data, (d)->
        return d.performance.memory.totalJSHeapSize
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
    for type in ['totalJSHeapSize','usedJSHeapSize']
        do(type)->
            lines[type] = d3.svg.line()
                .x((d,i)->
                    return xScale(i)
                ).y((d)->
                    return yScale(d.performance.memory[type])
                ).interpolate('linear')

    #Add to chart
    #------------------------------------
    lineGroups = svgEl.append('svg:g')
    
    #ALL entities
    lineGroups.append('svg:path')
        .data([data])
        .attr({
            d: lines.totalJSHeapSize
        })
        .style({
            fill: 'none'
            stroke: '#dd2222'
        })

    lineGroups.append('svg:path')
        .data([data])
        .attr({
            d: lines.usedJSHeapSize
        })
        .style({
            fill: 'none'
            stroke: '#22dddd'
        })
        
    return true
    
#=============================================================================
#Setup 
#=============================================================================
socket.emit('getLogData')
