# Install required packages
# install.packages("readxl")
# install.packages('ggplot2')
# install.packages('gganimate')

# Import libraries
library("readxl")
library(ggplot2)
library(gganimate)

# Read Excel file
df<-read_excel("C:\\Users\\profi\\Documents\\UNSW Civil Engineering\\Year 4\\T3\\Research Thesis CVEN4951\\Waymo Data\\Extracted_Data\\Used\\Frame Data (0000_10050)\\final_data200.xlsx", sheet = 'Raw')

# Inputs/Parameters
metric <- 'Average Speed' # Options: Flow, Density, Average Speed
unit <- 'v (km/h)' # Options: q (veh/h), k (veh/km), v (km/h)

# Convert column names to symbols
# Sourced from: https://stackoverflow.com/questions/22309285/how-to-use-a-variable-to-specify-column-name-in-ggplot
col_Time <- sym('Time (s)')
col_Dist <- sym('AV Cumulative Distance (m)')
col_Val <- sym(unit)

# Obtain number of frames in video
frame_num <- max(df$Frame)

# Assign colour scale to each traffic metric
if (metric == 'Density') {
color_min = 'green'
color_max = 'red'
} else {
color_min <- 'red'
color_max <- 'green'
}

# Plot time-space image (png)
# Soured from: https://goodekat.github.io/presentations/2019-isugg-gganimate-spooky/slides.html#13,
# https://www.datanovia.com/en/blog/gganimate-how-to-create-plots-with-beautiful-animation-in-r/
p <- ggplot(df, aes(x = !!col_Time, y = !!col_Dist, colour = !!col_Val)) +
    geom_point(show.legend = TRUE, alpha = 1, size=2) +
    labs(x = "Time (s)", y = "AV Distance Travelled (m)") +
    scale_color_gradient(
      low = color_min,
      high = color_max,
      space = 'Lab',
      guide = "colourbar")
title_p <- paste('Time-Space Diagram for ',metric, sep="")
ggsave(paste(title_p, '.png', sep = ""), plot = p + ggtitle(title_p))

# Plot time-space animation (gif)
anim <- p +
  geom_point() + transition_time(!!col_Time) +
  shadow_mark(alpha = 0.4, size = 2) +
  ggtitle(paste('Time-Space Diagram for',metric, sep=" "), subtitle='Frame {frame} of {nframes} ({round(progress*20, 1)}s)')
anim1 <- animate(plot = anim,
        nframes = frame_num,
        fps=10)
anim_save(paste('Time-Space Diagram for ',metric,'.gif', sep=""), anim1)

# Plot time-series image (png)
p2 <- ggplot(df, aes(x = !!col_Time, y = !!col_Val, colour = !!col_Val)) +
  geom_point(show.legend = TRUE, alpha = 1, size=2) +
  labs(x = "Time (s)", y = paste(metric, '-', unit, sep=" ")) +
  scale_color_gradient(
    low = color_min,
    high = color_max,
    space='Lab',
    guide = "colourbar")
title_p2 <- metric
ggsave(paste(title_p2, ' vs. Time.png', sep = ""), plot = p2 + ggtitle(title_p2))

# Plot time-series animation (gif)
anim2 <- p2 +
  geom_point() + transition_time(!!col_Time) +
  shadow_mark(alpha = 0.4, size = 2) +
  ggtitle(metric, subtitle='Frame {frame} of {nframes} ({round(progress*20, 1)}s)')
anim3 <- animate(plot = anim2,
                 nframes = frame_num,
                 fps=10)
anim_save(paste(metric,' vs. Time','.gif', sep=""), anim3)



