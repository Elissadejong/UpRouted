![alt text](istockphoto-996964906-612x612.jpg "UpRouted")

# UpRouted

>uproot verb<br> 
up·​root | \ (ˌ)əp-ˈrüt  , -ˈru̇t  \<br>
uprooted; uprooting; uproots<br>
Definition of uproot<br>
transitive verb<br>
1 : to remove as if by pulling up<br>
2 : to pull up by the roots<br>
3 : to displace from a country or traditional habitat<br>

## The research in a nutshell
Human trafficking is a form of modern-day slavery and includes recruiting, transporting, receiving or housing human beings through the use of force, fraud or coercion, for the purpose of exploitation. Combating human trafficking is challenging, like other types of organized crime, due to its subsurfaced nature, the use of well-structured (trans)national criminal networks and the fact that victims are often unable or afraid to seek help from law enforcement agencies. The following research aims to visualize the data on human trafficking in European countries and, in combination with a cluster analysis of the data of these countries, uncover possible human trafficking routes. The key purpose is to generate a way to find the routes of least resistance, weighted by EU membership in this case, as a procedure that could be recycled using different input- and conditional features. The core dataset was obtained from [THE COUNTER TRAFFICKING DATA COLLABORATIVE](https://www.ctdatacollaborative.org), made available in 2021. The references to the other datasets can be found in the 'countries data' chapter. 

### Research question
What are the routes of least resistance, by land, from the victims' countries of citizenship to the victims' countries of exploitation? 

## Libraries used
- [getpass](https://docs.python.org/3/library/getpass.html)
- [itertools](https://docs.python.org/3/library/itertools.html)(used during experimenting with different options, not applied in the final product)
- [matplotlib.pyplot](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.html)
- [numpy](https://numpy.org/doc/)
- [pandas](https://pandas.pydata.org/docs/)
- [pymysql](https://pymysql.readthedocs.io/en/latest/)
- [seaborn](https://seaborn.pydata.org)
- [scikit-learn](https://scikit-learn.org/stable/index.html)
- [sqlalchemy](https://www.sqlalchemy.org)
- [time](https://docs.python.org/3/library/time.html)
- [warnings](https://docs.python.org/3/library/warnings.html)

## Human trafficking data
- A targeted cleaning of the dataset
- Selecting only European and European-transcontinental countries with the use of ISO codes (alpha-3)
- Ed. null values of column 'yearofregistration' were not excluded in the final dataset, because it resulted in the total loss of data on victims in some countries (DNK, NLD, ...)

## Countries data
Due to a certain lack of adequate real data (e.g., border control measures per country), many available indices and variables reflecting countries only until about 2017, and the 'yearofregistration' time-span of the human trafficking data, the following mixture of data was chosen for this research in order to cluster countries:
- Global Competitiveness Index 2017-2018 (data for 2016) https://www.weforum.org/reports/the-global-competitiveness-report-2017-2018
- Corruption Perceptions Index 2016 https://www.transparency.org/en/cpi/2020/index/table
- Fragile States Index 2016 https://fragilestatesindex.org
- Global Slavery Index 2018 (data for 2017) https://www.globalslaveryindex.org
- Migration Integration Policy Index (fifth edition; covering 2007-2019) https://www.mipex.eu
- Country Statistics - UNData (data for 2017) https://www.kaggle.com/sudalairajkumar/undata-country-profiles

- Selecting only European and European-transcontinental countries
- Merging the 6 datasets into 1 dataset 

## Countries to clusters
- K-means cluster analysis with the entire dataset of the countries variables
- K-means cluster analysis solely with the countries' indices (this cluster analysis was settled on for continued analyses)
- Heatmaps to visualize cluster features and assign weights to the clusters:
    * cluster 0 = weight 0.75
    * cluster 3 = weight 0.50
    * cluster 2 = weight 0.25
    * cluster 1 = weight 0.00
- The weights were applied by analysing the heatmaps. The following features proved to differ most between clusters: governmental reponse to modern slavery, the Corruption Perceptions Index and the Fragile States Index
- The weights-range was chosen by hypothesizing that EU-membership has the biggest impact on a border crossing. Hence, if a country is in the EU the added weight is 0, if a country isn't the added weight is 1

## Route finder
- 108 international origin-destination combinations from human trafficking victims' countries of citizenship to the respective countries of exploitation
- Trial and error documentation (using itertools and a generator for "semi" filtered permutations, as well as a manual function to generate "fully" filtered permutations) 
- Finally, the route finder was generated in SQL as a procedure named RunBorders. The procedure consists of a recursive loop which loops through all country-border items (example format: ALB_GRC). The procedure is filtered so countries are not revisited and the border country of the previous item is the origin of the next item. The entire code of the procedure can be found in the UpRouted.sql file
- Input of the procedure is country of citizenship, country of exploitation and the maximum number of borders that can be crossed
- The maximum amount of borders to cross was set on 7
- A for loop containing SQL queries was generated to obtain a maximum of 10 routes of all possible routes from origin to destination 
- Weights were added per visited country to calculate the route of least resistance per distinct combination of origin and destination
- Note that no geographical information was used. Instead, this research defines route lengths by border crossing

## For the future - limitations
- The connection by road between France and the United Kingdom (the tunnel by Calais) was obviously not recognized as a border in the implemented dataset. Hence, the traffic 'by land' in question was unfortunately not yielded in the results of this research
- The data assembled does not resemble a sample of the human trafficking victims, nor does it provide complete information on the countries. However, the appropriate data was not available so a reflection rather than a representation was used
- The Migration Integration Policy index unfortunately did not include all the countries
- The human trafficking data missed many values in the 'citizenship' column
- The human trafficking data missed many values in the 'yearofregistration' column

## For the future - keep going
- Incorporate geographical/infrastructural data
- Experiment with a matrix as a route finder using an exhaustive search pattern
- Execute a logistic regression analysis using the countries' data 'origin' or 'destination' column and compare to findings of the cluster analysis to minimize countries' variables determining this outcome
- Apply and/or refine the generated procedure to other data on organized crime, as far as obtainable, in order to uproot the networks and routes used by the perpetrators. As well, with the proper finetuning, the procedure may be applied to flows of refugees
- Research the data over time
- Deep analyse the human trafficking victims features in combination with the cluster- and routes data
- Add a .py



