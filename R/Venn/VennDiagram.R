install.packages("VennDiagram")

library(VennDiagram)
#library(gridExtra)

# http://stackoverflow.com/questions/29253586/solvedplotting-venn-digrams-as-suplots-in-r
grid.newpage()

pushViewport(viewport(layout=grid.layout(ncol=2, nrow=2,  widths = unit(rep(1/2,2), "npc"))))

pushViewport(viewport(layout.pos.row=1,layout.pos.col=1))
gp1<-draw.pairwise.venn(area1 = 902675, area2 = 1217520, cross.area = 117932, 
                   category = c("PMR\n(86.9%)", "Illumina_1M\n(90.3%)"), 
                   lty = rep("blank", 2), 
                   fill = c("light blue", "pink"), 
                   alpha = rep(0.5, 2),
                   cat.pos = c(180, 180))
popViewport()




pushViewport(viewport(layout.pos.row=1,layout.pos.col=2))
gp2<-draw.pairwise.venn(area1 = 902675, area2 = 2326391, cross.area = 204285, 
                   category = c("PMR\n(77.4%)", "HumanOmni_2.5M\n(91.2%)"), 
                   lty = rep("blank", 2), 
                   fill = c("light blue", "light pink"), 
                   alpha = rep(0.5, 2),
                   cat.pos = c(180, 180))
popViewport()

pushViewport(viewport(layout.pos.row=2,layout.pos.col=1))
gp3<-draw.pairwise.venn(area1 = 902675, area2 = 827783, cross.area = 275628, 
                   category = c("PMR\n(69.5%)", "KORV1_1\n(66.7%)"), 
                   lty = rep("blank", 2), 
                   fill = c("light blue", "orange"), 
                   alpha = rep(0.5, 2),
                   cat.pos = c(180, 180))
popViewport()

pushViewport(viewport(layout.pos.row=2,layout.pos.col=2))
gp4<-draw.pairwise.venn(area1 = 902675, area2 = 833536, cross.area = 263990, 
                   category = c("PMR\n(70.8%)", "KORV1_0\n(68.3%)"), 
                   lty = rep("blank", 2), 
                   fill = c("light blue", "orange"), 
                   alpha = rep(0.5, 2),
                   cat.pos = c(180, 180))
popViewport()


# http://stackoverflow.com/questions/25092325/how-to-grid-arrange-in-grid-newpage

print(arrangeGrob(gp1,gp2,gp3,gp4), vp=...., newpage=FALSE)

