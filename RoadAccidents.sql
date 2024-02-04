

--Question 1: How many accidents have occurred in urban areas versus rural areas?

Select area, COUNT(accidentindex) as No_Of_Accidents
from accident
group by area

--Question 2: Which day of the week has the highest number of accidents?

Select Day, COUNT(accidentindex) as No_Of_Accidents
from accident
group by Day
order by No_Of_Accidents desc

--Question 3: What is the average age of vehicles involved in accidents based on their type?

select vehicletype, AVG(agevehicle) as Avg_Age_Of_Vehicles
from vehicle
group by VehicleType
order by Avg_Age_Of_Vehicles desc

--Question 4: Can we identify any trends in accidents based on the age of vehicles involved?

select agegrp,COUNT(accidentindex) as No_Of_Accidents
from (
		select accidentindex, 
		case 
		when agevehicle between 0 and 5 then 'New'
		when agevehicle between 6 and 10 then 'Semi - New'
		else 'Old'
		end as Agegrp
		from vehicle
) as subQ
group by agegrp
order by No_Of_Accidents desc;

--Observation:- The Old vehicles i.e., vehicles with their age above 10 years tend to be 
--more accident prone than that of the New and Semi - New vehicles.
--No. of Accidents by Old vehicles are 2.22 times more than that of New vehicles 
--and 2.32 times more than that of Semi - New vehicles.


--Question 5: Are there any specific weather conditions that contribute to severe accidents?

select weatherconditions, COUNT(accidentindex) as No_Of_Accidents
from accident
where severity = 'Fatal'
group by WeatherConditions, Severity
order by No_Of_Accidents desc

--Observation:- Surprisingly, majority of the fatal accidents occur 
--in 'fine no high winds' weather condition. Whereas, the no. of accidents occuring in
--'raining + high winds' weather condition is significantly low.

--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?

select LeftHand,COUNT(accidentindex) as No_Of_Accidents 
from vehicle
group by LeftHand
order by No_Of_Accidents desc

--Observation:- Most of the times, the impacts are not on the left-hand side of vehicles.

--Question 7: Are there any relationships between journey purposes and the severity of accidents?

select v.Journeypurpose, COUNT(v.accidentindex) as No_Of_Accidents,
Case 
	when COUNT(a.severity) between 0 and 1000 then 'Low'
	when COUNT(a.severity) between 1001 and 3000 then 'Moderate'
	when COUNT(a.severity) between 3001 and 10000 then 'High'
	Else 'Very High'
	End as Severity_Level
from vehicle v
join accident a on v.AccidentIndex=a.AccidentIndex
group by v.Journeypurpose
order by No_Of_Accidents desc

--Observation:- Purpose of journey of approx. 72% of the accidents are still unknown.

--Question 8: Calculate the average age of vehicles involved in accidents,
--considering Day light and point of impact:

select a.LightConditions,v.PointImpact, AVG(v.AgeVehicle) as Avg_Age_Of_Vehicle,
COUNT(v.accidentindex) as No_Of_Accidents
from vehicle v
join accident a on v.AccidentIndex=a.AccidentIndex
group by a.LightConditions, v.PointImpact
order by No_Of_Accidents desc, a.LightConditions, v.PointImpact
