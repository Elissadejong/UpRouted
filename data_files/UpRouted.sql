USE UpRouted;
drop table if exists UpRouted.countries_visited;
drop table if exists UpRouted.routes;
-- CREATE TABLE UpRouted.countries_visited(country_code varchar(3)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE UpRouted.routes(routeid bigint NOT NULL AUTO_INCREMENT, routestring varchar(2000),	EndSolution Boolean, PRIMARY KEY (routeid)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP PROCEDURE IF EXISTS UpRouted.RunBorders;

DELIMITER $$

CREATE PROCEDURE UpRouted.RunBorders(SourceCountryCode varchar(3), DestinationCountry varchar(3),RouteString varchar(2000), MaxBordersToCross integer)
BEGIN
    DECLARE done             INTEGER DEFAULT 0;
    DECLARE cc	             varchar(3);
    DECLARE children  CURSOR FOR SELECT country_border_code 
								 FROM UpRouted.borders_eur_database b
								 WHERE  b.country_code= SourceCountryCode and not RouteString like CONCAT('%%',b.country_border_code,'%%')
								 ORDER BY b.country_code;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	SET max_sp_recursion_depth = 25;
	IF RouteString IS NULL THEN
		SET RouteString = SourceCountryCode;
	ELSE
		SET RouteString = concat(RouteString, '_', SourceCountryCode);
    END IF;
	
	IF LENGTH(RouteString)<= ((MaxBordersToCross+1)*4) THEN
		OPEN children;
		countryloop: LOOP
			FETCH children INTO cc;
			IF done=1 THEN
				CLOSE children;
				LEAVE countryloop;
			END IF;
			IF cc IS NOT NULL THEN
				IF cc=DestinationCountry THEN
					SET RouteString = concat(RouteString, '_',cc);
					INSERT INTO UpRouted.routes(routestring, EndSolution) values(RouteString, True);
					SET done=1;
				ELSE
					CALL UpRouted.RunBorders(cc, DestinationCountry, RouteString, MaxBordersToCross);
				END IF;
			END IF;
		END LOOP countryloop;
	ELSE
		INSERT INTO UpRouted.routes(routestring, EndSolution) values(CONCAT('Too many borders crossed after: ', RouteString), False);
	END IF;
END$$

DELIMITER ;