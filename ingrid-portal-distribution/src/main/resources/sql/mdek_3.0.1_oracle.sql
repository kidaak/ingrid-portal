-- phpMyAdmin SQL Dump
-- version 2.11.9.2
-- http://www.phpmyadmin.net
--
--
-- Datenbank: mdek
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle help_messages
--

-- oracle way of: DROP TABLE IF EXISTS

-- !!!!!!!! -------------------------------------------------
-- !!! DIFFERENT SYNTAX FOR JDBC <-> Scripting !  Choose your syntax, default is JDBC version

-- !!! JDBC VERSION (installer):
-- !!! All in one line and DOUBLE SEMICOLON at end !!! Or causes problems when executing via JDBC in installer (ORA-06550) !

BEGIN execute immediate 'DROP TABLE help_messages'; exception when others then null; END;;

-- !!! SCRIPT VERSION (SQL Developer, SQL Plus):
-- !!! SINGLE SEMICOLON AND "/" in separate line !

-- BEGIN execute immediate 'DROP TABLE help_messages'; exception when others then null; END;
-- /

-- !!!!!!!! -------------------------------------------------

CREATE TABLE help_messages (
  id NUMBER(24,0) NOT NULL,
  version NUMBER(10,0) DEFAULT '0' NOT NULL,
  gui_id NUMBER(10,0),
  entity_class NUMBER(10,0),
  language VARCHAR2(2 CHAR),
  name VARCHAR2(255 CHAR),
  help_text CLOB,
  sample CLOB);

-- primary key
ALTER TABLE help_messages ADD CONSTRAINT PRIMARY_HelpMessages PRIMARY KEY ( id ) ENABLE;


--
-- Daten für Tabelle help_messages
--

INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES
(1, 0, 1000, -1, 'de', 'Adressen', 'Eintrag von Adressverweise zu Personen oder Institutionen, die weitergehende Informationen zum aktuellen Objekt geben können. Bei Bedarf können diese Verweise verändert werden. In der ersten Spalte wird jeweils die Art des Verweises eingetragen ( Auskunft, Datenhalter, etc.). Über den Link "Adresse hinzufügen" wird der Verweis selbst angelegt. Als Auswahlmöglichkeit stehen alle in der Adressverwaltung des aktuellen Kataloges bereits eingetragenen Personen zur Verfügung. Der Eintrag in der ersten Zeile (Auskunft) ist obligatorisch. Weiterhin ist hier ein Eintrag für Datenverantwortung verpflichtend, wenn ein INSPIRE-Thema ausgewählt wurde.', 'Auskunft / Robbe, Antje Datenhalter / Dr. Seehund, Siegfried');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(2, 0, 1010, 3, 'de', 'Beschreibung', 'Fachliche Inhaltsangabe des Geodatendienstes. Hier sollen in knapper Form die Art des Dienstes sowie die fachlichen Informationsgehalte beschrieben werden. Auf Verständlichkeit für fachfremde Dritte ist zu achten. DV-technische Einzelheiten sollten auf zentrale, kennzeichnende Aspekte beschränkt werden. Das Feld Beschreibungen muss ausgefüllt werden, damit das Objekt abgespeichert werden kann.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(3, 0, 1010, 0, 'de', 'Beschreibung', 'Fachliche Beschreibung der Organisationseinheit/Fachaufgabe. Im Falle einer Organisationseinheit sind die wesentlichen Zuständigkeitsbereiche/Fachaufgaben aufzuführen und ggf. kurz zu erläutern. Hierbei sollten die umweltbezogenen Fachaufgaben der Organisationseinheit im Vordergrund stehen. Ist das Objekt zur Beschreibung einer einzelnen Fachaufgabe angelegt worden, so ist diese Fachaufgabe näher zu erläutern (rechtliche Grundlage, organisatorische Rahmenbedingungen, Zielsetzung, ggf. Überschneidungen mit anderen Fachaufgaben). Auf Verständlichkeit für fachfremde Dritte ist zu achten. Das Feld Beschreibungen muss ausgefüllt werden, damit das Objekt abgespeichert werden kann.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(4, 0, 1010, 4, 'de', 'Beschreibung', 'Fachliche Inhaltsangabe des Vorhabens / Projektes / Programms. Hier sollen in knapper Form die Zielsetzungen und wichtigsten Rahmenbedingungen des Vorhabens / Projektes / Programms beschrieben werden. Auf Verständlichkeit für fachfremde Dritte ist zu achten. Für Detailinformationen (Name des Projektleiters, Projektbeteiligte, etc.) stehen gesonderte Eingabefelder zur Verfügung. Das Feld Beschreibungen muss ausgefüllt werden, damit das Objekt abgespeichert werden kann.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(5, 0, 1010, 5, 'de', 'Beschreibung', 'Fachliche Beschreibung der Datensammlung / Datenbank. Hier sollen in knapper Form die Hauptinhalte Datensammlung / Datenbank beschrieben werden. Hierbei sollte sich auf Parametergruppen beschränkt werden (z.B. Schwermetalle). Detaillierte Parameter können in einem gesonderten Feld eingetragen werden (siehe Fachbezug). Ferner sind ggf. die organisatorischen Rahmenbedingungen der Datensammlung / Datenbank von Interesse (Historie, Pflege, Nutzerkreis, Kooperationen). Auf Verständlichkeit für fachfremde Dritte ist zu achten. Das Feld Beschreibungen muss ausgefüllt werden, damit das Objekt abgespeichert werden kann.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(6, 0, 1010, 2, 'de', 'Beschreibung', 'Inhaltsangabe zum Dokument / Bericht / Literatur. Es ist eine kurze, aber Aussagekräfte Inhaltsangabe (Abstract) einzugeben. Diese Inhaltsangabe kann z.B. den Ausgangspunkt einer Untersuchung, eventuelle methodische Vorgehensweisen sowie die Hauptergebnisse enthalten. Auf Verständlichkeit für fachfremde Dritte ist zu achten. Für Detailinformationen (Autor, Erscheinungsjahr, etc.) stehen gesonderte Eingabefelder zur Verfügung. Das Feld Beschreibungen muss ausgefüllt werden, damit das Objekt abgespeichert werden kann.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(7, 0, 1010, 1, 'de', 'Beschreibung', 'Fachliche Inhaltsangabe der Geo-Information/Karte. Hier soll in knapper Form beschrieben werden, um welche Art von Geo-Information es sich handelt: - GIS-Daten, analoge Karte, Kartenwerk/Atlas - topographische Karte, politische Karte, fachbezogene Karte, etc. Ferner sollten die Hauptinhalte der dargestellten Sachinformationen genannt werden (z.B.: Pegelmessstellen, Kohlekraftwerke). Auf Verständlichkeit für fachfremde Dritte ist zu achten. Für Detailinformationen (Maßstäbe, etc.) stehen gesonderte Eingabefelder zur Verfügung. Das Feld Beschreibungen muss ausgefüllt werden, damit das Objekt abgespeichert werden kann.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(8, 0, 1020, -1, 'de', 'Objektklasse', 'Zuordnung des Objekts zu einer passenden Informationskategorie. Im Metadateneditor sind die verschiedenen Arten von Informationen in Informationskategorien eingeteilt (sog. Objektklassen). Die Objektklassen unterscheiden sich durch unterschiedliche Beschreibungsfelder in der Registerkarte Fachbezug. Es muss eine der folgenden Objektklasse ausgewählt werden: - Datensammlung/Datenbank: analoge oder digitale Sammlung von Daten. Beispiele: Messdaten, statistische Erhebungen, Modelldaten, Daten zu Anlagen - Dienst/Anwendung/Informationssystem: zentrale Auskunftssysteme, welche in der Regel auf eine oder mehrere Datenbanken zugreifen und diese zugänglich machen. - Dokument/Bericht/Literatur: Broschüren, Bücher, Aufsätze, Gutachten, etc. Von Interesse sind insbesondere Dokumente, welche nicht über den Buchhandel oder über Bibliotheken erhältlich sind ("graue Literatur") - Geo-Information/Karte: GIS-Daten, analoge Karten oder Kartenwerke - Organisationseinheit/Fachaufgabe: Zuständigkeiten von Institutionen oder Abteilungen, Fachgebiete, Fachaufgaben. - Vorhaben/Projekt/Programm: Forschungs- und Entwicklungsvorhaben, Projekte unter Beteiligung anderer Institutionen oder privater Unternehmen, Schutzprogramme; von besonderem Interesse sind Vorhaben/Projekte/Programme, in denen umweltrelevante Datenbestände entstehen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(9, 0, 1030, 0, 'de', 'Verantwortlicher', 'Eintrag von Adressverweise zu Personen oder Institutionen, die für dieses Objekt verantwortlich sind.', 'Mustermann, Erika');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(10, 0, 1130, -1, 'de', 'Minimum', 'Angabe der Werte für die Höhe über einem punkt (siehe Pegel) eingegeben. Ist eine vertikale Ausdehnung vorhanden, so kann für das Maximum ein größerer Wert eingegeben werden. Sollte dies nicht der Fall sein, so ist die Eingabe eines Minimalwerts ausreichend, dieser Wert wird dann automatisch ebenso für den Maximalwert übernommen.', 'Minimum 100, Maximum 110');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(11, 0, 1140, -1, 'de', 'Erläuterung', 'Zusätzliche Angaben zum Raumbezug.', 'Die Koordinaten für die Fachliche Gebietseinheit sind ungefähre Angaben.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(12, 0, 1220, -1, 'de', 'Status', 'Stand der Ausführung des Projektes, der Messung etc. Der Editor nimmt alle bekannten Umweltdaten auf, diese können sich in unterschiedlichen Stadien ihrer Lebenszeit befinden, d.h. Projekte, Programme oder Messungen können in konkreter Planung sein, derzeit durchgeführt werden oder schon abgeschlossen sein.', 'abgeschlossen');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(13, 0, 1230, -1, 'de', 'Intervall', 'Angabe des zeitlichen Abstands (Frequenz) der Datenerhebung. Erfolgt die Datenerhebung kontinuierlich oder periodisch (siehe Feld Periodizität), so soll diese Angabe hier präzisiert werden. Es stehen Felder für den freien Eintrag einer Ziffer und eine Auswahlliste zur Verfügung, die zeitliche Intervalle vorgibt. Der Eintrag von 10 und Tage bedeutet: Die beschriebenen Daten werden bzw. wurden alle 10 Tage erhoben.', 'Alle 6 Monate');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(14, 0, 1240, -1, 'de', 'Periodizität', 'Angabe des Zeitzyklus der Datenerhebung. Der Eintrag muss aus der Auswahlliste erfolgen, die über den Pfeil am Ende des Feldes geöffnet wird. Wichtig: Der Eintrag "unbekannt" sollte nicht mehr verwendet und falls noch in Altdaten vorhanden durch sinnvolle Einträge ersetzt werden. Er stellt eine nicht ISO-konforme Erweiterung der Auswahlliste dar.', 'täglich');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(15, 0, 1250, -1, 'de', 'Erläuterung', 'Zusätzliche Angaben zum Zeitbezug. Hier können z.B. die Angaben der Periodizität eingeschränkt, weitere Zeitangaben gemacht oder Unregelmäßigkeiten erklärt werden. Im Zusammenhang mit dem Eintrag im Feld Periodizität können hier Abstände, Perioden und Intervalle eingetragen werden, die sich nicht aus dem Zusammenhang der anderen Felder des Zeitbezuges erklären, z.B. Jahreszeiten, Dekaden, Tageszeiten.', 'Die Messungen erfolgten nur tagsüber.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(16, 0, 1310, -1, 'de', 'Medienoption', 'Angabe, auf welchen Medien die Daten zur Verfügung gestellt werden können. Hier können elektronische Datenträger als auch Medien in Papierform angegeben werden, auf denen die im Objekt beschriebenen Daten dem Nutzer zur Verfügung stehen. Es können mehrere Medien eingetragen werden. Medium: Angabe der Medien, auf denen der Datensatz bereit gestellt werden kann (ISO-Auswahlliste) Datenvolumen: Umfang des Datenvolumens in MB (Fließkommazahl) Speicherort: Ort der Datenspeicherung im Intranet/Internet, Angabe als Verweis', 'Medium: CD-ROM Datenvolumen: 700 MB Speicherort: Explorer Z:/Bereich_51/Metainformation/20040423_Hilfetexte.doc');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(17, 0, 1320, -1, 'de', 'Datenformat', 'Angabe des Formats der Daten in DV-technischer Hinsicht, in welchem diese verfügbar sind. Das Format wird durch 4 unterschiedliche Eingaben spezifiziert. Wenn die erste Spalte befüllt wird, müssen auch die anderen Eintragungen gemacht werden. Name: Angabe des Formatnamens, wie z.B. "Date" Version: Version der verfügbaren Daten (z.B. "Version 8" oder "Version vom 8.11.2001") Kompressionstechnik: Kompression, in welcher die Daten geliefert werden (z.B. "WinZip", "keine") Bildpunkttiefe: BitsPerSample.', 'Formatkürzel: tif Version: 6.0 Kompression: LZW Bildpunkttiefe: 8 Bit');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(18, 0, 1350, -1, 'de', 'Rechtliche Grundlage', 'Angabe der rechtlichen Grundlage, die die Erhebung der beschriebenen Daten veranlasst hat. Hier können Kürzel von Gesetzen, Erlassen, Verordnungen usw. eingetragen werden, in denen z. B. die Methode oder die Form der Erhebung der im Objekt beschriebenen Daten festgelegt oder beschrieben wird. Es ist bei Bedarf der Eintrag mehrerer Angaben möglich.', 'Niedersächsisches Naturschutzgesetz');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(19, 0, 1360, -1, 'de', 'Erläuterung', 'Angabe, warum die Daten erhoben werden.', 'Topographische Karten werden erstellt für den Nachweis des Landesgebietes.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(20, 0, 1370, -1, 'de', 'XML-Export-Kriterium', 'Eintrag eines Selektionskriteriums zur Steuerung des Exports der Daten. Um eine Teilmenge von Objekten exportieren zu können, kann in diesem Feld ein diese Teilmenge identifizierendes Schlagwort eingegeben werden. In der Exportfunktion kann dann eines der Schlagworte aus diesem Feld angegeben werden und alle Objekte exportiert werden, für die in diesem Feld das entsprechende Schlagwort vergeben wurde. Die Eingabe mehrerer Schlagworte ist möglich. Die Schlagworte können frei eingegeben werden. Zur Verhinderung von Schreibfehlern sollte jedoch der Eintrag aus der Auswahlliste vorgezogen werden.', 'CDS');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(21, 0, 1410, -1, 'de', 'Freie Schlagworte eintragen', 'Eingabe von Schlagworten, über die das Objekt bei einer Schlagwortsuche möglichst schnell zu finden ist und die nicht im Thesaurus vorhanden sind. Hier sollen prägnante Begriffe und Termini, die in engem Zusammenhang mit dem Objekt stehen und die nicht im Thesaurus vorhanden sind, eingetragen werden. Dies können spezielle Fachgebiete, (Mess-Methoden, Bestandteile o.ä. sein. Die Freien Suchbegriffe sind ergänzend zu den Thesaurus-Suchbegriffen anzugeben. Wenn Sie hier einen Thesaurusbegriff eingeben, wird dieser automatisch als Thesaurusbegriff gekennzeichnet.', 'Bestandsaufnahme; Rasterkarte; Nachtfalter');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(22, 0, 1420, -1, 'de', 'Optionale Schlagworte', 'Eingabe von möglichst mindestens drei Schlagworten, die im Thesaurus verzeichnet sind. Eingabe von möglichst mindestens drei Schlagworten, die im Thesaurus verzeichnet sind. Die Verschlagwortung dient dem themenbezogenen Wiederauffinden (Retrieval) der Objekte über den Thesaurus-Navigator. Dazu müssen Schlagworte aus dem Thesaurus ausgewählt werden, die das Objekt so genau wie möglich, aber auch so allgemein wie nötig beschreiben. So sollte mindestens ein Schlagwort in der Thesaurushierarchie einen relativ allgemeinen Aspekt des Objektes beschreiben und mindestens ein Schlagwort das Objekt so speziell wie möglich beschreiben. Die Auswahl kann über den "Verschlagwortungsassistenten" oder den "Thesaurus-Navigator" vorgenommen werden - siehe Verlinkung.', 'Naturschutz; Schmetterling; Kartierung; Artenschutz');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(23, 0, 1500, -1, 'de', 'Verweis zu', 'Es gibt die Möglichkeit, Verweise von einem Objekt zu einem anderen Objekt oder zu einer WWW-Adresse (URL) zu erstellen. In dieser Tabelle werden alle Verweise zusammenfassend aufgeführt, welche im aktuellen Objekt angelegt wurden. Über dem Link "Verweise anlegen/bearbeiten" öffnet sich ein Dialog, mit dem weitere Einzelheiten zu den Verweisen eingesehen und editiert werden können. Es ist ferner möglich, weitere Verweise über diesen Dialog hinzuzufügen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(24, 0, 1510, -1, 'de', 'Verweis von', 'In dieser Tabelle werden alle Verweise von denjenigen Objekten aufgeführt, welche auf das aktuelle Objekt verweisen. Das Editieren oder Hinzufügen ist nicht möglich. Sollen die Verweise geändert oder ergänzt werden, so muss zu dem entsprechenden Objekt gewechselt werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(25, 0, 2000, -1, 'de', 'Feldname / Bezeichnung der Verweisbeziehung', 'Angabe des fachlichen Bezuges, der zwischen dem aktuellen Objekt und dem Verweisobjekt (anderes Objekt, URL, OLE-Objekt) besteht. Die Beziehung des erstellten Verweises soll hier kurz und prägnant beschrieben werden (z. B. Datensammlung zum Gutachten, Literaturhinweis zur Datenerhebung). Über den Pfeil an der rechten Seite des Feldes kann aus einer Auswahlliste eine schon benutzte Beschreibung übernommen werden. Dieses Feld ist nur editierbar, wenn ein neuer Verweis erzeugt oder ein älterer aufgerufen wird. Einzutragen ist ein sprechender Name für den Verweis. Wurde der Dialog von einem Feld in einer anderen Registerkarte geöffnet, so wird automatisch der betreffende Feldname eingetragen und angezeigt (z.B. technische Dokumentation).', 'Literaturhinweis zum V-Modell');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(26, 0, 2100, -1, 'de', 'Objektname', 'Objektname des Objekts, auf das verwiesen werden soll. Der Verweis auf ein Objekt kann unabhängig von Strukturbaum und Hierarchie aus fachlichen Gründen gebildet werden. Die Eingabe erfolgt über eine Auswahl aus dem Strukturbaum, der über den Link "Objekt auswählen" geöffnet werden kann.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(27, 0, 2110, -1, 'de', 'Erläuterung', 'Anmerkungen zu dem erstellten Verweis. Hier können weitergehende Informationen zum Objekt eingegeben werden, auf das verwiesen wird. Es können auch Erläuterungen zu der Beziehung zwischen den beschriebenen Daten des aktuellen Objektes und den Daten des Verweis-Objektes gegeben werden.', 'Das Objekt, auf das verwiesen wird, enthält weiterführende Literaturhinweise zum aktuellen Objekt.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(28, 0, 2200, -1, 'de', 'Internet-Adresse (URL)', 'Angabe einer Internet-Adresse. Hier sollen Adressen eingegeben werden, bei denen im Internet Daten bzw. eine Anwendung zu finden sind, die mit den beschriebenen Daten in fachlichem Zusammenhang stehen oder bei der man die beschriebenen Daten im Internet ansehen kann.', 'http://www.landesbehörde.bundesland.de/ozondaten.html');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(29, 0, 2210, -1, 'de', 'Bezeichnung des Verweises', 'Eintrag einer aussagekräftigen Bezeichnung für den Verweis. Beispielsweise kann der sprechende Name der Webseite eingetragen werden.', 'Technische Dokumentation zum Luftüberwachungssystem Niedersachsen (LÜN)');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(30, 0, 2220, -1, 'de', 'Datenvolumen', 'Angabe über die Menge der Daten, die sich hinter der URL verbergen. Hier soll eine Angabe über die ungefähre Menge der Daten erfolgen, die bei Aufruf der URL zu übertragen sind. Der Eintrag soll in MB oder KB erfolgen.', '120 MB');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(31, 0, 2230, -1, 'de', 'Icon_Text', 'Text, der bei entsprechender Browser-Einstellung anstelle eines die Anwendung bzw. die Daten repräsentierenden Icons dargestellt wird.', 'NUMIS');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(32, 0, 2240, -1, 'de', 'Datentyp (Link Dialog)', 'Angabe des Dateiformats - es sind beliebige Einträge möglich z.B. JPG, HTML, XLS oder TXT', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(33, 0, 2250, -1, 'de', 'Icon_URL', 'Angabe einer URL, die ein Icon vorhält, das die verwiesenen Daten repräsentiert. Einer Anwendung oder Daten wird häufig ein signifikantes Icon zugeordnet. In diesem Feld soll die Internet-Adresse angegeben werden, wo dieses Icon zu finden ist.', 'http://www.landesbehörde.bundesland.de/flagge.gif');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(34, 0, 2251, -1, 'de', 'URL-Typ', 'Bei URL-Verweisen für ein Objekt wird unterschieden ob diese URL für das Internet oder für das Intranet gilt.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(35, 0, 2260, -1, 'de', 'Erläuterung', 'Anmerkungen zu dem erstellten Verweis. Hier können weitergehende Informationen zu der URL eingegeben werden, auf die verwiesen wird. Es können auch Erläuterungen zu der Beziehung zwischen den beschriebenen Daten des aktuellen Objektes und den Daten des Verweis-Objektes gegeben werden.', 'Es werden Java-Applets geladen');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(36, 0, 2300, -1, 'de', 'Bezeichnung des Verweises', 'Eintrag einer aussagekräftigen Bezeichnung für den Verweis. Wird beispielsweise ein Textdokument als OLE-Objekt eingebunden, so kann der Titel dieses Dokumentes eingetragen werden.', 'Technische Dokumentation zum Lüftüberwachungssystem Niedersachsen (LÜN)');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(37, 0, 3000, 3, 'de', 'Objektname', 'Angabe einer kurzen prägnanten Bezeichnung des beschriebenen Geodatendienstes. Der Objektname kann z.B. identisch mit dem Namen des Geodatendienstes sein, sofern dieser ausreichend kurz und aussagekräftig ist. Soweit ein gängiges Kürzel vorhanden ist, ist dieses Kürzel mit anzugeben. Der Eintrag in dieses Feld ist obligatorisch.', 'Emissions-Fernüberwachung EFÜ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(38, 0, 3000, 0, 'de', 'Objektname', 'Angabe einer kurzen, prägnanten Bezeichnung der beschriebenen Organisationseinheit oder Fachaufgabe.', 'Jahresstatistik zum Stand der Altlastenbearbeitung');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(39, 0, 3000, 4, 'de', 'Objektname', 'Angabe einer kurzen prägnanten Bezeichnung des beschriebenen Vorhabens / Projekts / Programms. Der Objektname kann z.B. identisch mit dem Titel des Vorhabens / Projekts / Programms sein, sofern dieser ausreichend kurz und aussagekräftig ist. Soweit ein gängiges Kürzel vorhanden ist, ist dieses Kürzel mit anzugeben. Der Eintrag in dieses Feld ist obligatorisch.', 'Moorschutzprogramm');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(40, 0, 3000, 5, 'de', 'Objektname', 'Angabe einer kurzen prägnanten Bezeichnung der beschriebenen Datensammlung / Datenbank. Der Objektname kann z.B. identisch mit dem Namen der Datenbank bzw. der Datensammlung sein, sofern dieser ausreichend kurz und aussagekräftig ist. Soweit ein gängiges Kürzel vorhanden ist, ist dieses Kürzel mit anzugeben. Der Eintrag in dieses Feld ist obligatorisch.', 'Anionenkonzentration in Abwasser');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(41, 0, 3000, 2, 'de', 'Objektname', 'Angabe einer kurzen prägnanten Bezeichnung des beschriebenen Dokumentes / Berichtes / der beschriebenen Literatur. Der Objektname kann z.B. identisch mit dem Titel des Dokumentes / des Berichtes / der Literatur sein, sofern dieser ausreichend kurz und aussagekräftig ist. Soweit ein gängiges Kürzel vorhanden ist, ist dieses Kürzel mit anzugeben. Der Eintrag in dieses Feld ist obligatorisch.', 'Schwermetallbelastung des Bodens im Umkreis von Deponien vor 1950.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(42, 0, 3000, 1, 'de', 'Objektname', 'Angabe einer kurzen, prägnanten Bezeichnung der beschriebenen Karte oder Geo-Information. Der Objektname kann z.B. identisch mit dem Namen der Karte oder der Geo-Information sein, sofern dieser ausreichend kurz und aussagekräftig ist. Soweit ein gängiges Kürzel vorhanden ist, ist dieses Kürzel mit anzugeben. Der Eintrag in dieses Feld ist obligatorisch.', 'Biotoptypenkarte');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(43, 0, 3100, 5, 'de', 'Methode / Datengrundlage', 'Angabe der verwendeten Methoden und der Datenherkunft. Hier sollen die angewandten Methoden der Datengewinnung (z.B. Meßmethode, Erhebungsmethode) benannt und beschrieben werden. Außerdem können Angaben z. B. zu Qualität oder Umfang der Datengrundlage eingetragen werden. Der Eintrag kann direkt erfolgen, wenn die Registerkarte "Text" gewählt wurde, oder als Verweis über die Registerkarte "Verweise".', 'Ionenchromatographie nach DIN 38405-D20 (Sept. 91)');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(44, 0, 3110, 5, 'de', 'Inhalte der Datensammlung', 'Angabe der wichtigsten Parameter der Datenbank bzw. der Datensammlung. Um einen qualifizierten Einblick in die beschriebene Datensammlung bzw. Datenbank zu bekommen, sollen hier die aussagekräftigen Parameter der vorgehaltenen Daten genannt werden. In der linken Spalte werden diese Parameter eingetragen. Beispiele für Parameter: im Falle von Messdaten werden die wichtigsten Messparameter (z.B. NOx, SO2, Windgeschwindigkeit, pH-Wert), im Falle von statistischen Erhebungen werden die Erhebungsgrößen (z.B. Wasserverbrauch pro Kopf, Bevölkerungsdichte), im Falle von Modelldaten werden die Modellparameter (z.B. Meeresspiegel, CO2-Gehalt der Luft, Welttemperatur) angegeben In der rechten Spalte können pro Parameter ergänzende Angaben gemacht werden. Beispielsweise kommen Angaben zur Maßeinheit, Genauigkeit, Nachweisgrenze, Probematrix oder parameterspezifische Angaben zur Meßmethode in Frage.', 'Blei / in Trinkwasser, Nachweisgrenze: 10 ppb Cadmium / in Schlacke, Nachweisgrenze: 3 ppm');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(45, 0, 3120, 5, 'de', 'Erläuterung', 'zusätzliche Angaben zur Datensammlung bzw. zur Datenbank', 'Die angegebenen Inhalte der Datenbank stellen nur eine Auswahl aller gemessenen Parameter dar (insgesamt ca. 300).');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(46, 0, 3200, 3, 'de', 'Systemumgebung', 'Angaben zum Betriebssystem und der Software, ggf. auch Hardware, die zur Implementierung des Dienstes eingesetzt wird.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(47, 0, 3210, 3, 'de', 'Basisdaten', 'Herkunft und Art der zugrundeliegenden Daten. Bei einem OGC Web Service können Verweise auf ein oder mehrere Objekte eingefügt werden, die mit dem Dienst eng verknüpft ("tightly coupled") sind. Im Allgemeinen sind dies die Datensätze, auf die der Dienst aufgesetzt ist. Bitte verwenden Sie hierzu möglichst einen "Verweis zu Dienst", der in dem die Basisdaten beschreibenden Objekt eingetragen wird (Klasse Geoinformation/Karte). Allgemein sollen die Herkunft oder die Ausgangsdaten der Daten beschrieben werden, die in dem Dienst benutzt, werden. Zusätzlich kann die Art der Daten (z. B. digital, automatisch ermittelt oder aus Umfrageergebnissen, Primärdaten, fehlerbereinigte Daten) angegeben werden. Der Eintrag kann hier direkt über die Auswahl der Registerkarte "Text" erfolgen oder es können Verweise eingetragen werden, indem der Link "Verweis anlegen/bearbeiten" angewählt wird.', 'Messdaten von Emissionen in bestimmten Betrieben bzw. Einfügen eines Verweises auf den "tightly coupled" OGC Web-Dienst');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(48, 0, 3220, 3, 'de', 'Art des Dienstes', 'In diesem Pflichtfeld kann die Art des Dienstes ausgewählt werden. Über das Feld werden die zur weiteren Befüllung auszuwählenden Angaben zu Operationen gesteuert.', 'Darstellungsdienst; Download-Dienst; Suchdienst');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(49, 0, 3230, 3, 'de', 'Version', 'Angaben zu Version der dem Dienst zugrunde liegenden Spezifikation. Bitte alle Versionen eintragen, die vom Dienst unterstützt werden.', '1.1.1 2.0');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(50, 0, 3240, 3, 'de', 'Historie', 'Angaben zur Implementierungsgeschichte des Dienstes.', '11.12.03: Installation des UMN Mapserver 3.0 auf Linux 2.2.005.04.04: Upgrade Linux 2.2.0 auf Linux 2.6.0 Modellversuch beim Gewerbeaufsichtsamt Osnabrück 1991; Einführung 1993');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(51, 0, 3250, 3, 'de', 'Erläuterung', 'Zusätzliche Anmerkungen zu dem beschriebenen Dienst. Hier können weitergehende Angaben z. B. technischer Art gemacht werden, die zum Verständnis des Dienstes notwendig sind.', 'Der Datensatz ist eine Shape-Datei, die alle Grundwassermessstellen in Hessen mit Lage und Kennung beinhaltet.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(52, 0, 3300, 2, 'de', 'Erscheinungsjahr', 'Angabe der Jahreszahl der Publikation der Literatur. Das Erscheinungsjahr ist vor allem für regelmäßig erscheinende Literatur wie z.B. jährliche Tagungsbände äußerst wichtig zur Identifikation. Das Erscheinungsjahr kann sich von den entsprechenden Angaben im Zeitbezug des Objektes unterscheiden, die sich auf den Inhalt der Literatur beziehen und nicht auf die Literatur selbst.', '1996');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(53, 0, 3310, 2, 'de', 'Erscheinungsort', 'Angabe des Publikationsortes der Literatur. Diese Angabe bezieht sich auf die Literatur und nicht auf die Inhalte der Literatur. Die räumliche Zuordnung der Inhalte der Literatur erfolgt in den Angaben zum Raumbezug des aktuellen Objektes.', 'Hamburg');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(54, 0, 3320, 2, 'de', 'Seiten', 'Angabe der Anzahl der Seiten der Literatur. Hier ist die Anzahl der Seiten anzugeben, wenn es sich um ein Buch handelt. Bei einem Artikel, der in einer Zeitschrift erschienen ist, sollen die Seitenzahlen des Artikelanfangs und des Endes eingegeben werden.', '345; 256-268');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(55, 0, 3330, 2, 'de', 'Band, Heft', 'Angabe der Zählung des betreffenden Bandes einer Reihe. Zeitschriften und Sammelwerke bzw. Reihen haben eine durchgängige Zählung seit ihrem Erscheinen oder pro Jahr. Hier ist die Zählung des Bandes anzugeben, in dem der Artikel bzw. der Bericht erschienen ist.', 'Band IV');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(56, 0, 3340, 2, 'de', 'Erschienen in', 'Angabe des Sammelwerkes, in dem ein Aufsatz erschienen ist. Aufsätze und andere nicht selbständige Literatur sind häufig als Teil einer Zeitschrift oder eines Buches erschienen oder als gedruckte Version eines Vortrages im Rahmen einer Tagung. Hier ist der Titel der Zeitschrift bzw. des Sammelwerkes (Tagungsband (Proceedings), Jahresberichte etc.) anzugeben, in der bzw. in dem die beschriebene Literatur erschienen ist. Unter diesem Titel kann ein Artikel beim Herausgeber bezogen werden.', 'Jahresberichte zur Abfallwirtschaft');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(57, 0, 3345, 2, 'de', 'Basisdaten', 'Verweis auf zugrunde liegende Daten. Hier sollen Verweise zu anderen Objekten dieses Katalogs gelegt werden, die Auskunft über Herkunft und Art der zugrunde liegenden Daten geben. Es kann über den Link (Verweis anlegen/bearbeiten) ein neuer Verweis angelegt werden.', 'Deponieüberwachung Berlin-Tegel, Statistikauswertungen seit 1974');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(58, 0, 3350, 2, 'de', 'Herausgeber', 'Angabe des Herausgebers. Der Herausgeber ist z. B. die Institution, in der ein Autor arbeitet und in deren Auftrag er geschrieben hat. Es kann auch ein Verlag, ein Verein oder eine andere Körperschaft sein, der/die Beiträge zu einem Thema sammelt und als Buch erscheinen lässt bzw. Bücher zu einem Thema als Reihe herausgibt.', 'Umweltbundesamt');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(59, 0, 3355, 2, 'de', 'Autor/Verfasser', 'Angabe des Autors bzw. des Verfassers der Literatur. Der Eintrag mehrerer Personen ist durch Semikolon zu trennen.', 'Angelika Müller; Hans Meier');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(60, 0, 3360, 2, 'de', 'Standort', 'Angabe des Aufbewahrungsortes und evtl. Bezugsort der Literatur, für den Fall, dass ein Bezug auf üblichem Wege (Handel, Bibliotheken) nicht möglich ist. Der Eintrag kann direkt über die Auswahl der Registerkarte "Text" erfolgen oder es können Adreßverweise eingetragen werden, indem die Registerkarte "Verweise" aktiviert und der Link "Adresse hinzufügen" betätigt werden. Es können Adressen nach Vorname, Nachname oder Name der Einheit/Institution des aktuellen Kataloges gesucht werden. Alternativ kann der Eintrag über den Hierarchiebaum erfolgen.', 'Bibliothek Umweltbundesamt');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(61, 0, 3365, 2, 'de', 'ISBN-Nr.', 'Angabe der 10-stelligen Identifikationsnummer der Literatur.', '3-456-7889-X');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(62, 0, 3370, 2, 'de', 'Verlag', 'Angabe des Verlages, in dem die Literatur erschienen ist.', 'econ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(63, 0, 3375, 2, 'de', 'Erläuterung', 'Zusätzliche Anmerkungen zur beschriebenen Literatur.', 'Der Artikel beruht auf der Diplomarbeit des Autors aus dem Jahr 1995 an der Universität');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(64, 0, 3380, 2, 'de', 'Weitere bibliographische Angaben', 'Hier können bibliographische Angaben gemacht werden, für die kein Feld explizit vorgesehen ist. Dies können z.B. Angaben zu Abbildungen oder zum Format sein. Wichtig ist auch ein Hinweis, wenn dem Dokument eine Diskette oder eine CD-ROM beiliegt bzw. es identisch auf CD-ROM erschienen ist.', 'Das Kartenwerk ist im DIN A3-Format erschienen.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(65, 0, 3385, 2, 'de', 'Dokumenttyp', 'Angabe der Art des Dokumentes. Es ist eine Kurzcharakteristik über die Art der Literatur anzugeben. Der Eintrag kann direkt erfolgen oder mit Hilfe einer Auswahlliste, die über den Pfeil am rechten Ende des Feldes geöffnet werden kann.', 'Zeitschriftenartikel');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(66, 0, 3400, 4, 'de', 'Projektleiter', 'Angabe des Projektleiters. Der Eintrag kann direkt über die Auswahl der Registerkarte "Text" erfolgen oder es können Adreßverweise ausgewählt werden, indem die Registerkarte "Verweise" aktiviert wird. Über den Link "Adresse hinzufügen" kann nach Adressen gesucht werden oder es können diese mit Hilfe des Hierachiebaums ausgewählt werden. ', 'Dr. Antje Robbe');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(67, 0, 3410, 4, 'de', 'Beteiligte', 'Angabe von Personen oder Institutionen, die am Projekt bzw. am Programm oder Vorhaben beteiligt sind. Der Eintrag soll Hinweise auf wichtige Institutionen oder Personen geben, die beteiligt waren bzw. sind und über die evtl. weitere genauere Informationen zu erfahren sind. Der Eintrag kann direkt über die Auswahl der Registerkarte "Text" erfolgen oder es können Adreßverweise eingetragen werden, indem die Registerkarte "Verweise" aktiviert wird. Über "Adresse hinzufügen" kann nach Adressen und Institutionen gesucht werden oder man kann diese über den Hierarchiebaum ausgewählten.', 'BfN, BMU');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(68, 0, 3420, 4, 'de', 'Erläuterungen', 'Weitere Angaben zum Projekt bzw. Programm oder Vorhaben. Hier können zusätzliche wichtige Angaben eingetragen werden, z.B. Finanzierung, Förderkennzeichen, Bearbeitungsstatus.', 'Finanzierung über BMU, EU');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(69, 0, 3500, 1, 'de', 'Raumbezugssystem', 'Angabe des Raumbezugssystems', 'EPSG:4326 / WGS 84 / geographisch');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(70, 0, 3515, 1, 'de', 'Herstellungsprozess', 'Angabe der Methode, die zur Erstellung des Datenobjektes geführt hat. Der Eintrag kann in Textform erfolgen, indem die Registerkarte "Text" ausgewählt wird. Außerdem kann durch Auswahl der Registerkarte "Verweise" ein Verweis erstellt werden.', 'Feldkartierung');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(71, 0, 3520, 1, 'de', 'Fachliche Grundlage', 'Angabe der Dokumente, die Grundlage der fachlichen Inhalte der Karte oder Datensammlung sind. Außerdem können Regeln für die Erfassung (Geo-Information) bzw. Darstellung (Karte) angegeben werden. Dieses Dokument kann eine Erläuterung der gesetzlichen Grundlagen darstellen, jedoch auch selbständigen Charakters sein. Der Eintrag kann in Textform erfolgen, indem die Karteikarte "Text" ausgewählt wird. Außerdem kann durch Auswahl der Registerkarte "Verweise" ein Verweis zu einem anderen Objekt im aktuellen Katalog erstellt werden. (INSPIRE-Pflichtfeld für Datasets und Data series)', 'Zeichenvorschrift');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(72, 0, 3525, 1, 'de', 'Erstellungsmaßstab', 'Angabe des Erstellungsmaßstabes, der sich auf die erstellte Karte und/oder Digitalisiergrundlage bei Geodaten bezieht. Maßstab: Maßstab der Karte, z.B 1:12 Bodenauflösung: Einheit geteilt durch Auflösung multipliziert mit dem Maßstab (Angabe in Meter, Fließkommazahl) Scanauflösung: Auflösung z.B. einer eingescannten Karte, z.B. 120dpi (Angabe in dpi, Integerzahl) (optionales INSPIRE-Feld)', 'Bodenauflösung: Auflösungseinheit in Linien/cm; Einheit: z.B. 1 cm geteilt durch 400 Linien multipliziert mit dem Maßstab 1:25.000 ergibt 62,5 cm als Bodenauflösung');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(73, 0, 3530, 1, 'de', 'Lagegenauigkeit', 'Angabe über die Genauigkeit z.B. in einer Karte', '0,5 m');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(74, 0, 3535, 1, 'de', 'Schlüsselkatalog', 'An dieser Stelle besteht die Möglichkeit, den Daten zugrunde liegende Klassifizierungsschlüssel zu benennen. Dabei ist die Eingabe mehrerer Kataloge mit zugehörigem Datum (Pflichteintrag) und Version (Optional) möglich.', 'Biotoptypenschlüssel, Datum 01.01.1998, Version 1.1');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(75, 0, 3555, 1, 'de', 'Symbolkatalog', 'Für die Präsentation genormter Objekte und Sachverhalte können für die Nutzer der Daten zur Herstellung von Karten abgestimmte Symbole vorgegeben werden. Die Angabe eines oder mehrerer analoger oder digitaler Symbolpaletten mit zugehörigem Datum (Pflichteintrag) und Version (Optional) ist hier möglich.', 'Planzeichenverordnung, Datum 01.01.1998, Version 1.0');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(76, 0, 3565, 1, 'de', 'Erfassungsgrad', 'Eingabe einer Prozentangabe zum Stand der Erfassung des Datenobjektes. Diese kann sich auf die Anzahl der Kartenblätter aber auch auf den Erfassungsgrad einer Gesamtkarte beziehen.', '55');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(77, 0, 3570, 1, 'de', 'Datengrundlage', 'Angabe der Unterlagen (Luftbilder, Karten, Datensammlungen), die bei der Erstellung der Karte oder der Geo-Information (des digitalen Datenbestandes) Verwendung finden. Der Eintrag kann in Textform erfolgen, indem die Karteikarte "Text" ausgewählt wird. Außerdem kann durch Auswahl der Registerkarte "Verweise" ein Verweis zu einem anderen Objekt im aktuellen Katalog erstellt werden.', 'Kartieroriginale der Pflanzenerfassung');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(78, 0, 3571, -1, 'de', 'Veröffentlichung', 'Das Feld Veröffentlichung gibt an, welche Veröffentlichungsmöglichkeiten für das Objekt freigegeben sind. Die Liste der Möglichkeiten ist nach Freigabestufen hierarchisch geordnet. Wird einem Objekt eine niedrigere Freigabestufe zugeordnet (z.B. von Internet auf Intranet), werden automatisch auch alle untergeordneten Objekte dieser Stufe zugeordnet. Soll einem Objekt eine höhere Freigabestufe zugeordnet werden als die des übergeordneten Objektes, wird die Zuordnung verweigert. Wird einem Objekt eine höhere Freigabestufe zugeordnet (z.B. von Amtsintern auf Intranet), kann auch allen untergeordneten Objekten die höhere Freigabestufe zugeordnet werden.', 'Die Einstellung haben folgende Bedeutung: Internet: Das Objekt darf überall veröffentlicht werden; Intranet: Das Objekt darf nur im Intranet veröffentlicht werden, aber nicht im Internet; Amtsintern: Das Objekt darf nur in der erfassenden Instanz aber weder im Internet noch im Intranet veröffentlicht werden.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(79, 0, 4000, 3, 'de', 'Name', 'Name einer Person (Pflichtfeld), für die eine freie Adresse eingetragen werden soll. Hinweis: Diese Maske dient dem Eintrag sog. freier Adressen von Personen. Hierunter werden Adressen verstanden, die nicht hierarchisch aufgebaut sind (Institution/Einheit/Person). Der Eintrag freier Adressen kann dann sinnvoll sein, wenn eine Person keiner Institution zuzuordnen ist oder wenn man die Adresse von nur einem Mitarbeiter einer Institution eintragen will.', 'vom Busche');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(80, 0, 4005, 3, 'de', 'Vorname', 'Angabe des Vornamens der eingetragenen Person. Um Verwechslungen von Trägern gleicher Nachnamen zu vermeiden, soll hier der Vorname der eingetragenen Person genannt werden. Auf Vollständigkeit der Vornamen wird dabei kein Wert gelegt.', 'Rosemarie');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(81, 0, 4010, 3, 'de', 'Institution', 'Name der Institution, der die Person angehört. Falls die Dienst- oder Geschäftsadresse der Person angelegt werden soll, so ist hier der Name der Institution einzutragen, der die Person angehört. Evtl. kann in einer weiteren Zeile auch die betreffende Einheit (Abteilung, Referat, Dezernat, etc.) eingetragen werden.', 'Landesanstalt für Umweltschutz');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(82, 0, 4015, 3, 'de', 'Anrede', 'Angabe der Anrede für die eingetragene Person. Um eine korrekte Korrespondenz mit der eingetragenen Person zu ermöglichen, soll diese Angabe falsche Anreden der eingetragenen Person vermeiden. Die Standardeinträge (Frau, Herr) sind in der Auswahlliste enthalten. Freie Einträge sind jedoch auch möglich (z.B. Mrs, Mr).', 'Frau');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(83, 0, 4020, 3, 'de', 'Titel', 'Angabe des akademischen Titels der eingetragenen Person. Hier sollen die dem Namen vorangestellten akademischen Titel angegeben werden. Amtstitel (z.B. MinD, OAR) sollen aus Datenschutzgründen nicht eingetragen werden.', 'Prof. Dr.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(84, 0, 4100, 0, 'de', 'Institution', 'Name der Institution. Hier soll die vollständige, offizielle Bezeichnung der Institution eingetragen werden. Eine Institution ist eine offizielle, selbständige organisatorische Einheit. Dies kann z. B. eine Behörde, ein Amt oder eine Firma sein. Um die zuständigen Personen zu präzisieren, können der Institution Einheiten und Personen zugeordnet werden, die dann detaillierte Angaben zu der Einheit und der Person enthalten. Einer Institution kann auch eine Person direkt zugeordnet werden. Eine Institution kann auch alleine, ohne zugeordnete Personen oder Einheiten in den Adressverweisen der Objekte eingetragen werden.', 'Landesanstalt für Umweltschutz');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(85, 0, 4200, 1, 'de', 'Einheit', 'Name der Einheit. Hier soll die vollständige, offizielle Bezeichnung der Einheit eingetragen werden. Eine Einheit stellt eine organisatorische Untergliederung einer übergeordneten Institution dar. Es ist möglich, eine Einheit unter einer anderen Einheit anzuordnen (z.B. Referat/Dezernat XY unter Abteilung Z).', 'Referat 606 (DV-Organisation, Umweltinformationssysteme)');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(86, 0, 4210, -1, 'de', 'Institution/Übergeordnete Einheiten)', 'Es werden die übergeordnete Institution und die übergeordneten Einheiten angezeigt.', 'Ministerium für Umwelt und Klimaschutz');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(87, 0, 4300, 2, 'de', 'Anrede', 'Angabe der Anrede für die eingetragene Person. Um eine korrekte Korrespondenz mit der eingetragenen Person zu ermöglichen, soll diese Angabe falsche Anreden der eingetragenen Person vermeiden. Die Standardeinträge (Frau, Herr) sind in der Auswahlliste enthalten. Freie Einträge sind jedoch auch möglich (z.B. Mrs, Mr).', 'Frau');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(88, 0, 4305, 2, 'de', 'Titel', 'Angabe des akademischen Titels der eingetragenen Person. Hier sollen die dem Namen vorangestellten akademischen Titel angegeben werden. Amtstitel (z.B. MinD, OAR) sollen aus Datenschutzgründen nicht eingetragen werden.', 'Prof. Dr.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(89, 0, 4310, 2, 'de', 'Vorname', 'Angabe des Vornamens der eingetragenen Person. Um Verwechslungen von Trägern gleicher Nachnamen zu vermeiden, soll hier der Vorname der eingetragenen Person genannt werden. Auf Vollständigkeit der Vornamen wird dabei kein Wert gelegt.', 'Rosemarie');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(90, 0, 4315, 2, 'de', 'Name', 'Angabe des Nachnamens der eingetragenen Person. Hier soll der vollständige Nachname einer Person eingetragen werden.', 'vom Busche');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(91, 0, 4400, 0, 'de', 'Straße/Hausnummer', 'Angabe der Hausadresse. Bei der Straße und Hausnummer der Institution sollte es sich um die Adresse der Zentrale bzw. des Hauptgebäudes handeln. Für die zuzuordnenden Einheiten und Personen können eigene Adressen eingetragen werden. Die Angabe der Hausadresse ist Pflicht, sofern kein Postfach angegeben wird.', 'Meyersgrund 14');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(92, 0, 4400, 2, 'de', 'Straße/Hausnummer', 'Angabe der Hausadresse. Bei der Straße und Hausnummer der Person sollte es sich um die Hausadresse des Dienstgebäudes der Person handeln. Die Angabe einer Hausadresse ist Pflicht, sofern kein Postfach angegeben wird.', 'Blocksberg 17');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(93, 0, 4400, 3, 'de', 'Straße/Hausnummer', 'Angabe der Hausadresse. Bei der Straße und Hausnummer der Person sollte es sich um die Hausadresse des Dienstgebäudes der Person handeln. Fehlt der Eintrag für die Institution, ist hier i.d.R. die Privatanschrift einzutragen. Die Angabe einer Hausadresse ist Pflicht, sofern kein Postfach angegeben wird.', 'Blocksberg 17');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(94, 0, 4400, 1, 'de', 'Straße/Hausnummer', 'Angabe der Hausadresse. Bei der Straße und Hausnummer der Einheit sollte es sich um die Adresse des Dienstgebäudes dieser Einheit handeln. Für die zuzuordnenden Personen können eigene Adressen eingetragen werden. Die Angabe einer Hausadresse ist Pflicht, sofern kein Postfach angegeben wird.', 'Vogelfangtrift 15');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(95, 0, 4405, 0, 'de', 'Staat', 'Angabe des Staates, in dem die Adresse liegt. Er muss aus der der Auswahlliste ausgewählt werden.', 'Deutschland');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(96, 0, 4410, -1, 'de', 'PLZ', 'Postleitzahl der Hausadresse (Straße/Hausnummer). Hier ist die Postleitzahl einzugeben, die sich auf die Hausadresse (Straße/Hausnummer) bezieht. Für die Postleitzahl zur Postdresse (Postfach) ist ein eigenes Feld vorgesehen.', '30169');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(97, 0, 4415, 0, 'de', 'Ort', 'Es ist der Ort anzugeben, wo sich die Zentrale bzw. das Hauptgebäude der Institution befindet. Für die zuzuordnenden Einheiten und Personen können eigene Adressen bzw. Ortsangaben eingetragen werden. Für den Fall, dass der Ort für Hausadresse (Straße/Hausnummer) und Postadresse (Postfach) verschieden ist, kann nur eine vollständige Adresse eingetragen werden (Haus- oder Postadresse).', 'Bruchsal');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(98, 0, 4415, 2, 'de', 'Ort', 'Es ist der Ort anzugeben, wo sich das Dienstgebäude befindet, in dem die betreffende Person tätig ist. Für die zugeordnete Institution/Einheiten können eigene Adressen bzw. Ortsangaben eingetragen werden. Für den Fall, dass der Ort für Hausadresse (Straße/Hausnummer) und Postadresse (Postfach) verschieden ist, kann nur eine vollständige Adresse eingetragen werden (Haus- oder Postadresse).', 'Wolgast');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(99, 0, 4415, 3, 'de', 'Ort', 'Es ist der Ort anzugeben, wo sich das Dienstgebäude befindet, in dem die betreffende Person tätig ist. Soll die Privatadresse der betreffenden Person angegeben werden, ist hier der Wohnort anzugeben. Für den Fall, dass der Ort für Hausadresse (Straße/Hausnummer) und Postadresse (Postfach) verschieden ist, kann nur eine vollständige Adresse eingetragen werden (Haus- oder Postadresse).', 'Wolgast');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(100, 0, 4415, 1, 'de', 'Ort', 'Es ist der Ort anzugeben, wo sich das Dienstgebäude der Einheit befindet. Für die zuzuordnenden weiteren Einheiten und Personen können eigene Adressen bzw. Ortsangaben eingetragen werden. Für den Fall, dass der Ort für Hausadresse (Straße/Hausnummer) und Postadresse (Postfach) verschieden ist, kann nur eine vollständige Adresse eingetragen werden (Haus- oder Postadresse).', 'Wolgast');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(101, 0, 4420, -1, 'de', 'Postfach', 'Angabe der Nummer des Postfaches. In Ergänzung zur Hausadresse (Straße/Hausnummer) kann hier ein Postfach angegeben werden. Ist keine Hausadresse angegeben, so ist die Eingabe eines Postfaches zwingend notwendig, um die Adresse speichern zu können. Für den seltenen Fall, dass keine Hausadresse existiert und die Postleitzahl bereits die Nummer des Postfachs darstellt (also keine gesonderte Postfachnummer existiert), ist hier ein Leerzeichen einzutragen.', '30151');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(102, 0, 4425, -1, 'de', 'PLZ (Postfach)', 'Postleitzahl des Postfaches. Hier ist die Postleitzahl einzugeben, die sich auf das Postfach bezieht. Für die Postleitzahl zur Hausadresse (Straße/Hausnummer) ist ein eigenes Feld vorgesehen.', '8977');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(103, 0, 4430, 0, 'de', 'Kommunikation', 'Angabe von Telefonnummern, Faxnummer, E-Mail, URL-Adresse usw. In dieser Tabelle sollen alle Kommunikationsmittel (außer normaler Post) eingetragen werden, mit denen die Institution erreicht werden kann.  Die Bezeichnung kann über eine Auswahlliste eingegeben werden. In der rechten Spalte wird die zugehörige Nummer für Telefon oder Fax bzw. Adresse für E-Mail-Kommunikation eingegeben. Wichtig: Die Angabe der E-Mail Adresse ist Pflicht! (INSPIRE-Pflichtfeld)', 'E-Mail : pressestelle@mu.niedersachsen.de');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(104, 0, 4430, 2, 'de', 'Kommunikation', 'Angabe von Telefonnummern, Faxnummer, E-Mail, URL-Adresse usw. In dieser Tabelle sollen alle Kommunikationsmittel (außer normaler Post) eingetragen werden, mit denen die Person erreicht werden kann.  Die Bezeichnung kann über eine Auswahlliste eingegeben werden. In der rechten Spalte wird die zugehörige Nummer für Telefon oder Fax bzw. Adresse für E-Mail-Kommunikation eingegeben. Wichtig: Die Angabe der E-Mail Adresse ist Pflicht! (INSPIRE-Pflichtfeld)', 'antje.robbe@mu.niedersachsen.de');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(105, 0, 4430, 3, 'de', 'Kommunikation', 'Angabe von Telefonnummern, Faxnummer, E-Mail, URL-Adresse usw. In dieser Tabelle sollen alle Kommunikationsmittel (außer normaler Post) eingetragen werden, mit denen die Person oder Institution erreicht werden kann.  Die Bezeichnung kann über eine Auswahlliste eingegeben werden. In der rechten Spalte wird die zugehörige Nummer für Telefon oder Fax bzw. Adresse für E-Mail-Kommunikation eingegeben. Wichtig: Die Angabe der E-Mail Adresse ist Pflicht! (INSPIRE-Pflichtfeld)', 'antje.robbe@mu.niedersachsen.de');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(106, 0, 4430, 1, 'de', 'Kommunikation', 'Angabe von Telefonnummern, Faxnummer, E-Mail, URL-Adresse usw. In dieser Tabelle sollen alle Kommunikationsmittel (außer normaler Post) eingetragen werden, mit denen die Einheit erreicht werden kann.  Die Bezeichnung kann über eine Auswahlliste eingegeben werden. In der rechten Spalte wird die zugehörige Nummer für Telefon oder Fax bzw. Adresse für E-Mail-Kommunikation eingegeben. Wichtig: Die Angabe der E-Mail Adresse ist Pflicht! (INSPIRE-Pflichtfeld)', 'pressestelle@mu.niedersachsen.de');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(107, 0, 4435, 0, 'de', 'Notizen', 'Weitere Angaben zur Institution. Hier können für die Datenauskunft zusätzlich relevante Information eingegeben werden. Dies können z. B. Öffnungszeiten oder Beschreibungen des Anfahrtsweges sein.', 'Besucherverkehr: MO-FR 9-12 Uhr; DO 14-19 Uhr');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(108, 0, 4435, 2, 'de', 'Notizen', 'Weitere Angaben zur Personenadresse. Hier können für die Datenauskunft zusätzlich relevante Information eingegeben werden. Dies können z. B. Öffnungszeiten oder Angaben zur zeitlichen Erreichbarkeit sein.', 'vormittags erreichbar');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(109, 0, 4435, 3, 'de', 'Notizen', 'Weitere Angaben zur Personenadresse. Hier können für die Datenauskunft zusätzlich relevante Information eingegeben werden. Dies können z. B. Öffnungszeiten oder Angaben zur zeitlichen Erreichbarkeit sein.', 'vormittags erreichbar');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(110, 0, 4435, 1, 'de', 'Notizen', 'Weitere Angaben zur Einheit bzw. Abteilung. Hier können für die Datenauskunft zusätzlich relevante Information eingegeben werden. Dies können z. B. Öffnungszeiten oder Beschreibungen des Anfahrtsweges sein.', 'Besucherverkehr: MO-FR 9-12 Uhr; DO 14-19 Uhr');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(111, 0, 4440, 0, 'de', 'Aufgaben', 'Angabe der Zuständigkeiten und Aufgaben einer Institution. In knapper, aussagekräftiger Form sollen die Aufgaben und Zuständigkeiten der eingetragenen Institution dargestellt werden.', 'Erarbeitung von fachlichen Grundlagen für Entscheidungen der Bezirksregierungen im Bereich des Naturschutzes sowie Erstellung von Gutachten in besonderen Fällen gemäß NNatG');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(112, 0, 4440, 2, 'de', 'Aufgaben', 'Angabe der Zuständigkeiten und Aufgaben einer Person. In knapper, aussagekräftiger Form sollen die Aufgaben und Zuständigkeiten der eingetragenen Person dargestellt werden.', 'Vorbereitung von Ausweisungen von Naturschutzgebieten; Erarbeitung von Abgrenzungen der Gebiete; Verordnungsentwurf');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(113, 0, 4440, 3, 'de', 'Aufgaben', 'Angabe der Zuständigkeiten und Aufgaben einer Person. In knapper, aussagekräftiger Form sollen die Aufgaben und Zuständigkeiten der eingetragenen Person dargestellt werden.', 'Vorbereitung von Ausweisungen von Naturschutzgebieten; Erarbeitung von Abgrenzungen der Gebiete; Verordnungsentwurf');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(114, 0, 4440, 1, 'de', 'Aufgaben', 'Angabe der Zuständigkeiten und Aufgaben einer Einheit. In knapper, aussagekräftiger Form sollen die Aufgaben und Zuständigkeiten der eingetragenen Einheit bzw. Abteilung dargestellt werden.', 'Erarbeitung von fachlichen Grundlagen für Ausweisung von Naturschutzgebieten sowie Erstellung von Gutachten gemäß NNatG.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(115, 0, 4500, 0, 'de', 'Freie Schlagworte eintragen', 'Eingabe von Schlagworten, über die die Institution bei einer Schlagwortsuche möglichst schnell zu finden ist und die nicht im Thesaurus vorhanden sind. Hier sollen prägnante Begriffe und Termini, die in engem Zusammenhang mit dem Adresse stehen und die nicht im Thesaurus vorhanden sind, eingetragen werden. Dies können Fachgebiete, Zuständigkeiten o.ä. sein. Die Freien Suchbegriffe sind ergänzend zu den Thesaurus-Suchbegriffen anzugeben. Wenn Sie hier einen Thesaurusbegriff eingeben, wird dieser automatisch als Thesaurusbegriff gekennzeichnet.', 'Naturschutz Artenschutz Erfassung');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(116, 0, 4500, 2, 'de', 'Freie Schlagworte eintragen', 'Eingabe von Schlagworten, über die die Person bei einer Schlagwortsuche möglichst schnell zu finden ist und die nicht im Thesaurus vorhanden sind. Hier sollen prägnante Begriffe und Termini, die in engem Zusammenhang mit dem Adresse stehen und die nicht im Thesaurus vorhanden sind, eingetragen werden. Dies können Fachgebiete, Zuständigkeiten o.ä. sein. Die Freien Suchbegriffe sind ergänzend zu den Thesaurus-Suchbegriffen anzugeben. Wenn Sie hier einen Thesaurusbegriff eingeben, wird dieser automatisch als Thesaurusbegriff gekennzeichnet.', 'Falter Kartierung');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(117, 0, 4500, 3, 'de', 'Freie Schlagworte eintragen', 'Eingabe von Schlagworten, über die die Person bei einer Schlagwortsuche möglichst schnell zu finden ist und die nicht im Thesaurus vorhanden sind. Hier sollen prägnante Begriffe und Termini, die in engem Zusammenhang mit dem Adresse stehen und die nicht im Thesaurus vorhanden sind, eingetragen werden. Dies können Fachgebiete, Zuständigkeiten o.ä. sein. Die Freien Suchbegriffe sind ergänzend zu den Thesaurus-Suchbegriffen anzugeben. Wenn Sie hier einen Thesaurusbegriff eingeben, wird dieser automatisch als Thesaurusbegriff gekennzeichnet.', 'Falter Kartierung');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES
(118, 0, 4500, 1, 'de', 'Freie Schlagworte eintragen', 'Eingabe von Schlagworten, über die die Einheit bei einer Schlagwortsuche möglichst schnell zu finden ist und die nicht im Thesaurus vorhanden sind. Hier sollen prägnante Begriffe und Termini, die in engem Zusammenhang mit dem Adresse stehen und die nicht im Thesaurus vorhanden sind, eingetragen werden. Dies können Fachgebiete, Zuständigkeiten o.ä. sein. Die Freien Suchbegriffe sind ergänzend zu den Thesaurus-Suchbegriffen anzugeben. Wenn Sie hier einen Thesaurusbegriff eingeben, so wird automatisch vorgeschlagen, diesen in das Feld für die Thesaurusbegriffe zu übernehmen. Wird ein Synonym zu einem Thesaurusbegriff eingegeben, so wird die zusätzliche automatische Übernahme des zugehörigen Thesaurusbegriffs vorgeschlagen.', 'Artenschutz Kartierung');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(119, 0, 4510, 0, 'de', 'Optionale Schlagworte', 'Eingabe von möglichst mindestens drei Schlagworten, die im Thesaurus verzeichnet sind. Die Verschlagwortung dient dem themenbezogenen Wiederauffinden (Retrieval) der Adresse. Dazu müssen Schlagworte aus dem Thesaurus ausgewählt werden, die die Adresse so genau wie möglich, aber auch so allgemein wie nötig beschreiben. So sollte mindestens ein Schlagwort in der Thesaurushierarchie einen relativ allgemeinen Aspekt der Adresse beschreiben und mindestens ein Schlagwort die Adresse so speziell wie möglich beschreiben. Die Schlagworte können mit Hilfe des Verschlagwortungsassistenten (es werden Schlagworte vorgeschlagen) oder dem Thesaurus-Navigator ausgewählt werden.', 'Naturschutz; Schmetterling; Kartierung; Artenschutz');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(120, 0, 4510, 2, 'de', 'Optionale Schlagworte', 'Eingabe von möglichst mindestens drei Schlagworten, die im Thesaurus verzeichnet sind. Die Verschlagwortung dient dem themenbezogenen Wiederauffinden (Retrieval) der Adresse. Dazu müssen Schlagworte aus dem Thesaurus ausgewählt werden, die die Adresse so genau wie möglich, aber auch so allgemein wie nötig beschreiben. So sollte mindestens ein Schlagwort in der Thesaurushierarchie einen relativ allgemeinen Aspekt der Adresse beschreiben und mindestens ein Schlagwort die Adresse so speziell wie möglich beschreiben. Die Schlagworte können mit Hilfe des Verschlagwortungsassistenten (es werden Schlagworte vorgeschlagen) oder dem Thesaurus-Navigator ausgewählt werden.', 'Naturschutz; Schmetterling; Kartierung; Artenschutz');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(121, 0, 4510, 3, 'de', 'Optionale Schlagworte', 'Eingabe von möglichst mindestens drei Schlagworten, die im Thesaurus verzeichnet sind. Die Verschlagwortung dient dem themenbezogenen Wiederauffinden (Retrieval) der Adresse. Dazu müssen Schlagworte aus dem Thesaurus ausgewählt werden, die die Adresse so genau wie möglich, aber auch so allgemein wie nötig beschreiben. So sollte mindestens ein Schlagwort in der Thesaurushierarchie einen relativ allgemeinen Aspekt der Adresse beschreiben und mindestens ein Schlagwort die Adresse so speziell wie möglich beschreiben. Die Schlagworte können mit Hilfe des Verschlagwortungsassistenten (es werden Schlagworte vorgeschlagen) oder dem Thesaurus-Navigator ausgewählt werden.', 'Naturschutz; Schmetterling; Kartierung; Artenschutz');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(122, 0, 4510, -1, 'de', 'Optionale Schlagworte', 'Eingabe von möglichst mindestens drei Schlagworten, die im Thesaurus verzeichnet sind. Die Verschlagwortung dient dem themenbezogenen Wiederauffinden (Retrieval) der Adresse. Dazu müssen Schlagworte aus dem Thesaurus ausgewählt werden, die die Adresse so genau wie möglich, aber auch so allgemein wie nötig beschreiben. So sollte mindestens ein Schlagwort in der Thesaurushierarchie einen relativ allgemeinen Aspekt der Adresse beschreiben und mindestens ein Schlagwort die Adresse so speziell wie möglich beschreiben. Die Schlagworte können mit Hilfe des Verschlagwortungsassistenten (es werden Schlagworte vorgeschlagen) oder dem Thesaurus-Navigator ausgewählt werden.', 'Naturschutz; Schmetterling; Kartierung; Artenschutz');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(123, 0, 4520, -1, 'de', 'Höhe', 'Angabe der Werte für die Höhe im angegebenen Referenz System (Vertikaldatum).  Ist eine vertikale Ausdehnung vorhanden, so kann für das Maximum ein größerer Wert eingegeben werden. Sollte dies nicht der Fall sein, so ist die Eingabe eines Minimums ausreichend, dieser Wert wird dann automatisch ebenso für den maximalen übernommen.', '100 m');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(124, 0, 5000, 0, 'de', 'Kurzbezeichnung', 'Angabe einer Kurzbezeichnung für ein Objekt. (Wird insbes. von GeoMIS.Bund unterstützt)', 'DTK25 digitale topographische Karte GK25 - Grundkarte');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(125, 0, 5020, -1, 'de', 'Maximum', 'Angabe der Werte für die Höhe im angegebenen Referenz System (Vertikaldatum).  Ist eine vertikale Ausdehnung vorhanden, so kann für das Maximum ein größerer Wert eingegeben werden. Sollte dies nicht der Fall sein, so ist die Eingabe eines Minimums ausreichend, dieser Wert wird dann automatisch ebenso für den maximalen übernommen.', 'Minimum 100, Maximum 110');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(126, 0, 5021, -1, 'de', 'Maßeinheit', 'Angabe der Maßeinheit, in der die Höhe gemessen wird.', 'Meter');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(127, 0, 5022, -1, 'de', 'Vertikal Datum', 'Angabe des Referenzpegels, zu dem die Höhe relativ gemessen wird. In Deutschland ist dies i.A. der Pegel Amsterdam.', 'Pegel Amsterdam');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(128, 0, 5030, -1, 'de', 'Zeitbezug des Datensatzes', 'Angabe, wann der Datensatz erstellt, revidiert und/oder publiziert wurde.', '11.11.2003 Erstellung');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(129, 0, 5040, -1, 'de', 'Eignung/Nutzung', 'Angaben über die Verwendungsmöglichkeiten, die diese Daten in Verbindung mit weiteren Informationen erfüllen können.', 'Präsentation des Raumordnungsprogramms auf Basis der topografischen Kartenwerke');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(130, 0, 5041, -1, 'de', 'Sprache des Metadatensatzes', 'Angabe der Sprache des Metadatensatzes.', 'Deutsch');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(131, 0, 5042, -1, 'de', 'Sprache des Datensatzes', 'Angabe der Sprache des Datensatzes.', 'Deutsch');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(132, 0, 5052, -1, 'de', 'Bestellinformation', 'Angabe von generellen Informationen wie Bedingungen oder Konditionen zur Bestellung.', 'Lieferzeit beträgt 3 Wochen');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(133, 0, 5060, 1, 'de', 'Themenkategorie', 'Angabe der Hauptthemen, welche die Metadaten beschreiben. Die Auswahl erfolgt über die vorgegebene Auswahlliste.', 'Umwelt');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(134, 0, 5061, 1, 'de', 'Datensatz/Datenserie', 'Bei den beschriebenen Daten der Klasse Geo-Information/Karte handelt es sich um einen einzelnen Datensatz mit bestimmtem räumlichen Bezug oder um eine Datenserie mit einheitlichem thematischen Bezug und mehreren Datensätzen mit unterschiedlichem räumlichen Bezug (z.B. Datenserie: DTK25)', 'Datensatz');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(135, 0, 5062, 1, 'de', 'Digitale Repräsentation', 'Angabe der Methode, räumliche Daten zu präsentieren. Die Auswahl erfolgt über eine vorgegebene Liste.', 'Vektor');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(136, 0, 5063, 1, 'de', 'Topologieinfo', 'Achtung: Nur aktiv nach Auswahl von "Vektor" bei "Digitale Repräsentation". Es erscheint hier dann eine Auswahlliste mit Begriffen.', 'geometrisch');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(137, 0, 5064, 1, 'de', 'INSPIRE-Themen', 'Auswahl eines INSPIRE Themengebiets zur Verschlagwortung des Datensatzes (INSPIRE-Pflichtfeld)', 'Boden');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(138, 0, 5066, 1, 'de', 'Verweis zu Dienst', 'Georeferenzierte Daten, die Basisdaten eines OGC Web-Dienstes sind, können über dieses Feld einen Verweis auf einen beschriebenen OGC Web-Dienst erhalten. Diese Geodaten sind in der Regel eng mit dem Dienst verknüpft ("tightly coupled") und über den verknüpften OGC Web Service direkt erreichbar.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(139, 0, 5069, 1, 'de', 'Höhengenauigkeit', 'Angabe über die Genauigkeit der Höhe z.B. in einem Geländemodell.', '2');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(140, 0, 5070, 1, 'de', 'Sachdaten / Attributinformation', 'Angabe der mit der Geo-Information/Karte verbundenen Sachdaten. Bei Bedarf kann hier eine Auflistung der Attribute des Datenbestandes erfolgen. Die hauptsächliche Nutzung dieses Feldes ist für digitale Geo-Informationen vorgesehen.', 'Baumkartei');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(141, 0, 5201, 3, 'de', 'Name der Operation', 'Name der von einem Dienst bereitgestellten Funktion/Operation. Hier muss ein eindeutiger Bezeichner für die beschriebene Operation eingegeben werden.', 'getMap getCapabilities getFeatureInfo');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(142, 0, 5202, 3, 'de', 'Beschreibung', 'Textliche Beschreibung der Funktionalität der Operation.', 'Die getMap Operation des WMS gibt eine Raster-Repräsentation der in "Basisdaten" beschriebenen digitalen Karte zurück.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(143, 0, 5203, 3, 'de', 'Unterstütze Plattformen', 'Angaben zur Art der Plattform bzw. Schnittstelle über die der Dienst angesprochen werden kann.', 'Java SQL HTTPGet HTTPSoap');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(144, 0, 5204, 3, 'de', 'Aufruf', 'Eindeutiger Funktionsname über den die Operation aufgerufen werden kann. Bei OGC Web-Diensten sind die jeweiligen spezifizierten REQUEST-Aufrufe zu verwenden.', 'getMap getCapabilities getFeatureInfo');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(145, 0, 5205, 3, 'de', 'Parameter', 'Mögliche Parameter, die bei einem Aufruf der Operation übergeben werden können. - Name/Bezeichner des Parameters. - Richtung des Datenflusses, der durch diesen Parameter erzeugt wird. - Textliche Beschreibung des Parameters. - Ist Optional: Angabe, ob der Parameter optional ist oder nicht. - Angabe, ob eine Mehrfacheingabe des Parameters möglich bzw. notwendig ist.', 'Name: WIDTH Richtung: Eingabe Beschreibung: "Der Parameter WIDTH definiert die Breite des vom WMS erzeugten Kartenbildes" Ist Optional: Ja Mehrfacheingabe: Nein');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(146, 0, 5206, 3, 'de', 'Zugriffsadresse', 'Eindeutige URL über die die Operation aufgerufen werden kann.', 'http://my.host.com/cgi-bin/mapserv?map=mywms.map&');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(147, 0, 5207, 3, 'de', 'Abhängigkeiten', 'Die Namen der Operationen, die vor dem Ausführen der aktuellen Operation ausgeführt werden müssen wenn die Operation als Teil einer Service Chain genutzt werden soll.', 'Für die "getMap" Operation: "getCapabilities"');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(148, 0, 7000, -1, 'de', 'Fachbezug', 'Die Objektklassen unterscheiden sich durch unterschiedliche Beschreibungsfelder in der Registerkarte Fachbezug:\n- Organisationseinheit/Fachaufgabe: Zuständigkeiten von Institutionen oder Abteilungen, Fachgebiete, Fachaufgaben.\n- Geo-Information/Karte: GIS-Daten, analoge Karten oder Kartenwerke.\n- Dokument/Bericht/Literatur: Broschüren, Bücher, Aufsätze, Gutachten, etc. Von Interesse sind insbesondere Dokumente, welche nicht über den Buchhandel oder über Bibliotheken erhältlich sind (''graue Literatur'').\n- Geodatendienst: Dienste die raumbezogene Daten zur Verfügung stellen, insbesondere Dienste im Rahmen von INSPIRE, der GDI-DE oder der GDIs der Länder.\n- Vorhaben/Projekt/Programm: Forschungs- und Entwicklungsvorhaben, Projekte unter Beteiligung anderer Institutionen oder privater Unternehmen, Schutzprogramme; von besonderem Interesse sind Vorhaben/Projekte/Programme, in denen umweltrelevante Datenbestände entstehen.\n- Datensammlung/Datenbank: Analoge oder digitale Sammlung von Daten. Beispiele: Messdaten, statistische Erhebungen, Modelldaten, Daten zu Anlagen.\n- Dienst/Anwendung/Informationssystem: zentrale Auskunftssysteme, welche in der Regel auf eine oder mehrere Datenbanken zugreifen und diese zugänglich machen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(149, 0, 7001, -1, 'de', 'Raumbezugssystem', 'Angabe der Bezugssysteme (Lage, Höhe, Schwere), die der Erarbeitung des zu beschreibenden Datenbestandes oder der fertigen Karte zugrunde gelegt wurden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(150, 0, 7002, -1, 'de', 'Zeitbezug', 'Angabe des Zeitbezugs des Datensatzes und des Dateninhalts', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(151, 0, 7003, -1, 'de', 'Zusatzinformation', 'Angabe von allgemeinen Daten wie Sprache und Ort der Veröffentlichung des Datensatzes', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(152, 0, 7004, -1, 'de', 'Verfügbarkeit', 'Angabe, ob und in welcher Form es Zugangs- oder Nutzungsbeschränkungen gibt', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(153, 0, 7005, -1, 'de', 'Verschlagwortung', 'Angabe von Schlagworten, um die Suche nach Daten zu verbessern', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(154, 0, 7006, -1, 'de', 'Als Katalogseite anzeigen', 'Auswahl, ob Datenobjekt als Katalogseite in PortalU bzw. ingrid angezeigt werden soll', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(155, 0, 7007, -1, 'de', 'Verweise', 'Anzeige von Verweisen auf andere Objekte/URLs und Möglichkeit der Neueingabe bzw. Bearbeitung von Verweisen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(156, 0, 7008, -1, 'de', 'Adresse und Aufgaben - Sektionsüberschrift', 'Angabe von Adressdaten zur Kommunikation mit entsprechender Kontaktstelle, sowie Zusatzinformationen (Notizen und Aufgaben) zu dieser', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(157, 0, 7009, -1, 'de', 'Verschlagwortung - Sektionsüberschrift', 'Angabe von Schlagworten, um die Suche nach den Adressdaten zu vereinfachen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(158, 0, 7010, -1, 'de', 'Zugeordnete Objekte', 'In dieser Tabelle werden alle Verweise von denjenigen Objekten aufgeführt, welche auf die aktuelle Adresse verweisen. Das Editieren oder Hinzufügen ist nicht möglich. Sollen die Verweise geändert oder ergänzt werden, so muss zu dem entsprechenden Objekt gewechselt werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(159, 0, 7011, -1, 'de', 'Allgemeines', 'Eintrag von allgemeinen Informationen zum Objekt (Beschreibung, Kontaktinformation)', 'Mustermann, Erika');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(160, 0, 7012, -1, 'de', 'i-Info Umgerechnete Koordinaten', 'Umrechnung der unter Geothesaurus-Raumbezug ausgewählten Daten in die in der Auswahlbox zur Verfügung stehenden Koordinatensysteme', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(161, 0, 7013, -1, 'de', 'i-Info Umgerechnete Koordinaten - freie Raumbezüge', 'Umrechnung der unter freier Raumbezug ausgewählten Daten in die in der Auswahlbox zur Verfügung stehenden Koordinatensysteme', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(162, 0, 7014, -1, 'de', 'Vektorformat', 'Achtung: Nur aktiv nach Auswahl von "Vektor" bei "Digitale Repräsentation". Es können hier Topologieinformationen, Geometrietyp (Angabe der geometrischen Objekte, zur Beschreibung der geometrischen Lage) und Elementanzahl (Angaben der Anzahl der Punkt- oder Vektortypelemente) angegeben werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(163, 0, 7015, -1, 'de', 'Operationen', 'Angabe von Operationen bezüglich Webdiensten wie getMap, getCapabilities und getFeatureInfo', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(164, 0, 7016, -1, 'de', 'Objekte anlegen/bearbeiten', 'Formular zum Anlegen und Bearbeiten von Metadatenobjekten der 7 verschiedenen Objektklassen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(165, 0, 7017, -1, 'de', 'Einheit/Institution', 'Angabe des Namens der Einheit bzw. Institution, nach der gesucht werden soll', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(166, 0, 7018, -1, 'de', 'Nachname', 'Angabe des Namens der Person, nach der gesucht werden soll', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(167, 0, 7019, -1, 'de', 'Vorname', 'Angabe des Vornamens der Person, nach der gesucht werden soll', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(168, 0, 7020, -1, 'de', 'Geothesaurus-Navigator - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(169, 0, 7021, -1, 'de', 'Geothesaurus-Navigator - Räumliche Einheit festlegen', 'Eingabe der Räumlichen Einheit, deren Koordinaten gesucht werden sollen z.B. Berlin', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(170, 0, 7022, -1, 'de', 'Raumbezug hinzufügen', 'Hier können die Koordinaten einer Bounding Box angegeben werden, die das Objekt umschließt. Bei einer punktförmigen Ortsangabe wird zweimal die gleiche Koordinate angegeben: Länge1=Länge2 und Breite1=Breite2', ' ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(171, 0, 7023, -1, 'de', 'Freier Raumbezug (Eingabefeld)', 'Angabe eines frei wählbaren Namens für den neuen Raumbezug.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(172, 0, 7024, -1, 'de', 'Unten links: Rechtswert / Länge', 'Angabe des x-Werts der unteren linken Koordinate der Bounding Box', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(173, 0, 7025, -1, 'de', 'Unten links (Hochwert/Breite)', 'Angabe des y-Werts der unteren linken Koordinate der Bounding Box', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(174, 0, 7026, -1, 'de', 'Oben rechts (Rechtswert/Länge)', 'Angabe des x-Werts der oberen rechten Koordinate der Bounding Box', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(175, 0, 7027, -1, 'de', 'Oben Rechts (Hochwert/Breite)', 'Angabe des y-Werts der oberen rechten Koordinate der Bounding Box', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(176, 0, 7028, -1, 'de', 'Koordinatensystem', 'Auswahl des für die Koordinatenangabe verwendeten Koordinatensystems aus einer Liste.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(177, 0, 7029, -1, 'de', 'Verschlagwortungsassistent', 'Hier werden Schlagworte auf Basis der bereits ausgefüllten Textfelder automatisch vorgeschlagen und können bei Bedarf übernommen werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(178, 0, 7030, -1, 'de', 'Thesaurus-Navigator', 'Hier kann nach Diskriptoren oder Ordnungsbegriffen im Thesaurus gesucht werden oder es können Schlagworte direkt im Hierarchiebaum ausgewählt werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(179, 0, 7031, -1, 'de', 'Suche nach Deskriptoren und Ordnungsbegriffen', 'Suche nach Diskriptoren oder Ordnungsbegriffen im Thesaurus. Die Ergebnisse der Suche werden auf dem Karteiblatt "Ergebnisliste" angezeigt und können von dort aus übernommen werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(180, 0, 7032, -1, 'de', 'Liste der Deskriptoren', 'Anzeige der aus dem Hierarchiebaum oder der Such-Ergebnisliste hinzugefügten Deskriptoren. Über den Button "Übernehmen" werden diese bei den Thesaurus-Suchbegriffen ergänzt.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(181, 0, 7033, -1, 'de', 'Verweise anlegen/bearbeiten', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(182, 0, 7034, -1, 'de', 'Verweis von', 'Auf der rechten Seite unter "Verweisliste" werden alle vorhandenen Verweise zu anderen Objekten oder URLs aufgelistet. Durch die Anwahl dieser können die Verweise editiert werden. Über den Button "Neu" können neue Verweise hinzugefügt werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(183, 0, 7035, -1, 'de', 'Objektname', 'Anzeige des Namens des aktuell in Bearbeitung befindlichen Objekts.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(184, 0, 7037, -1, 'de', 'Verweistyp', 'Auswahl, ob auf Objekte des Katalogs oder auf Webseiten (URLs) verwiesen werden soll.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(185, 0, 7038, -1, 'de', 'Verweis auf', 'Anzeige des Objekts oder der URL auf die der Verweis zielt. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(186, 0, 7040, -1, 'de', 'Objektklasse', 'Hier wird die Klasse des Objekts angezeigt, auf welche der Verweis zielt.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(187, 0, 7041, -1, 'de', 'Operation hinzufügen /bearbeiten', 'Angabe von Operationen bezüglich Webdiensten wie getMap, getCapabilities und getFeatureInfo', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(188, 0, 7042, -1, 'de', 'Kommentare ansehen/hinzufügen', 'Ansehen und Verfassen von Kommentaren zum Objekt', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(189, 0, 7043, -1, 'de', 'Neuen Kommentar verfassen', 'Verfassen eines neuen Kommentars zum Objekt', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(190, 0, 7044, -1, 'de', 'Adresstitel - Formularkopf', 'Angabe eines frei wählbaren Namens für das Adressobjekt', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(191, 0, 7045, -1, 'de', 'Adresstyp - Formularkopf', 'Angabe des Typs des Adressobjekts - Institution, Einheit oder Person', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(192, 0, 7046, -1, 'de', 'Erweiterte Suche Objekte - Thema - Suchmodus', 'Entscheidung, ob nach ganzen Suchwörtern oder nach Teilzeichenketten gesucht werden soll', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(193, 0, 7047, -1, 'de', 'Erweiterte Suche Objekte - Thema - Fachwörterbuch - Bitte geben Sie die Thesaurus-Begriffe an, nach denen gesucht werden soll', 'Eingabe eines (Thesaurus-) Begriff, zu dem ähnliche Begriffe gesucht werden sollen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(194, 0, 7048, -1, 'de', 'Erweiterte Suche Objekte - Thema - Fachwörterbuch - Suchbegriffe', 'aus Thesaurus-Suche übernommene Suchbegriffe, mit denen ein Datenobjekt gefunden werden soll', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(195, 0, 7049, -1, 'de', 'Erweiterte Suche Objekte - Raum - Geothesaurus-Raumbezug - Bitte geben Sie die Raumbezüge an, nach denen gesucht werden soll', 'Eingabe von räumlichen Begriffen, mit denen im Geothesaurus gesucht werden soll z.B. Berlin', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(196, 0, 7050, -1, 'de', 'Erweiterte Suche Objekte - Raum - Geothesaurus-Raumbezug - Suchbegriffe', 'Aus der Geothesaurus-Suche übernommene Begriffe, die den Raumbezug eines Datenobjekts beschreiben', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(197, 0, 7051, -1, 'de', 'Erweiterte Suche Objekte - Raum - Freier Raumbezug', 'Auswahl eines im Katalog verwendeten freien Raumbezugs, zur Suche nach Datenobjekten', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(198, 0, 7052, -1, 'de', 'Erweiterte Suche Objekte - Zeit - Zeitbezug', 'Angabe eines Zeitpunkts oder Zeitraums zur Lokalisierung eines Objekts (Suche nach "Zeitbezug des Dateninhaltes")', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(199, 0, 7053, -1, 'de', 'Erweiterte Suche Objekte - Zeit - Erweiterung des Zeitbezuges', 'Angabe, ob der Zeitpunkt/Zeitraum des gesuchten Objekts innerhalb oder außerhalb des oben angegeben Zeitbezugs liegt', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(200, 0, 7054, -1, 'de', 'Erweiterte Suche Adressen - Thema - Suchmodus', 'Entscheidung, ob nach ganzen Suchwörtern oder nach Teilzeichenketten gesucht werden soll', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(201, 0, 7055, -1, 'de', 'Erweiterte Suche Adressen - Thema - Suche in folgenden Feldern', 'Entscheidung, ob in allen Textfeldern eines Datenobjekts oder nur in bestimmten gesucht werden soll', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(202, 0, 7056, -1, 'de', 'Erweiterte Suche Adressen - Raum - Fügen Sie hier Ihrer Suchanfrage konkrete Adressinformationen zu', 'Suche von Adressobjekten nach Adressinformationen wie Strasse, PLZ oder Ort', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(203, 0, 7057, -1, 'de', 'Erweiterte Suche Adressen - Raum - Straße', 'Suche nach Straßennamen in einem Adressobjekt', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(204, 0, 7058, -1, 'de', 'Erweiterte Suche Adressen - Raum - PLZ', 'Suche nach Postleitzahlen in einem Adressobjekt', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(205, 0, 7059, -1, 'de', 'Erweiterte Suche Adressen - Raum - Ort', 'Suche nach Ortsnamen in einem Adressobjekt', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(206, 0, 7060, -1, 'de', 'Suche - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(207, 0, 7061, -1, 'de', 'Thesaurusnavigator - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(208, 0, 7062, -1, 'de', 'Thesaurusnavigator - Einstieg in die Thesaurus-Hierarchie', 'Suche nach Thesaurusbegriffen und deren Position im Thesaurus-Hierarchiebaum', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(209, 0, 7063, -1, 'de', 'Datenbank-Suche - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(210, 0, 7064, -1, 'de', 'Datenbank-Suche - Datenbank-Suche', 'Suche nach Objekten mit Hilfe der Hibernate Query Language-Syntax (HQL)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(211, 0, 7065, -1, 'de', 'Qualitätssicherung - Bearbeitung/Verantwortlich - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(212, 0, 7066, -1, 'de', 'Qualitätssicherung - Bearbeitung/Verantwortlich - Objekte / Adressen deren Verfallszeitspanne abgelaufen ist', 'Anzeige von Objekten und Adressen, die überprüft werden müssen, da Verfallszeitspanne abgelaufen ist', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(213, 0, 7067, -1, 'de', 'Qualitätssicherung - Bearbeitung/Verantwortlich - Objekte / Adressen die sich in von Ihnen derzeit in Bearbeitung befinden', 'Anzeige von Objekten und Adressen die sich im Bearbeitungszustand befinden d.h. nicht veröffentlicht sind', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(214, 0, 7068, -1, 'de', 'Qualitätssicherung - Bearbeitung/Verantwortlich - Objekte / Adressen die an die Qualitätssicherung überwiesen bzw. von der Qualitätssicherung rücküberweisen wurden', 'Anzeige von Objekten, die sich im Qualitätssicherungszyklus befinden d.h. sind nicht veröffentlicht', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(215, 0, 7069, -1, 'de', 'Qualitätssicherung - Qualitätssicherung - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(216, 0, 7070, -1, 'de', 'Qualitätssicherung - Qualitätssicherung - Objekte / Adressen die Ihnen als Qualitätssichernder zugewiesen wurden', 'Anzeige von Objekten/Adressen, die die Qualitätssicherung überprüfen muss', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(217, 0, 7071, -1, 'de', 'Qualitätssicherung - Qualitätssicherung - Objekte / Adressen die sich in Bearbeitung befinden, für die Sie Qualitätssichernder sind', 'Anzeige von Objekten/Adressen, die die Qualitätssicherung überprüfen muss', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(218, 0, 7072, -1, 'de', 'Qualitätssicherung - Qualitätssicherung - Objekte / Adressen deren Verfallszeitspanne abgelaufen ist, für die Sie Qualitätssichernder sind', 'Anzeige von Objekten/Adressen, für die Sie als QS-Beauftragter zuständig sind u. überarbeitet werden', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(219, 0, 7073, -1, 'de', 'Qualitätssicherung - Qualitätssicherung - Objekte deren Raumbezug abgelaufen ist, für die Sie Qualitätssichernder sind', 'Anzeige von Objekten/Adressen, deren Raumbezug abgelaufen ist und für die Sie als QS zuständig sind - müssen von Ihnen überprüft werden', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(220, 0, 7074, -1, 'de', 'Objekt auswählen', 'Mit Hilfe des Strukturbaums kann ein Objekt ausgewählt werden, auf welches verwiesen werden soll. Nach der Auswahl ist noch der Button "Zuweisen" zu betätigen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(221, 0, 8000, -1, 'de', 'Katalogeinstellungen', 'Angabe von Informationen zum Katalog wie z.B. Name des Katalogs, Anbieter oder Sprache des Katalogs', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(222, 0, 8001, -1, 'de', 'Name des Katalogs', 'Der Name des Katalogs sollte den Inhalt des Katalogs widerspiegeln.', 'UDK Niedersachsen');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(223, 0, 8002, -1, 'de', 'Name des Partners', 'Angabe des Namens des Partners', 'Bund');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(224, 0, 8003, -1, 'de', 'Name des Anbieters', 'Angabe des Namen des Anbieters', 'Ministerium für Landwirtschaft und Umwelt Sachsen-Anhalt');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(225, 0, 8004, -1, 'de', 'Staat', 'Angabe des Staates, in dem der Katalog basiert', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(226, 0, 8005, -1, 'de', 'Katalogsprache', 'Angabe der Sprache des Katalogs', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(227, 0, 8006, -1, 'de', 'Raumbezug', 'Hier kann über die Schaltfläche "Raumbezug auswählen" die Räumliche Einheit ausgewählt werden', 'Minden-Lübbecke');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(228, 0, 8007, -1, 'de', 'Raumbezug auswählen', 'Hier kann nach eine räumliche Einheit für den Katalog ausgewählt werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(229, 0, 8008, -1, 'de', 'Räumliche Einheit festlegen', 'Hier kann ein Ort angegeben werden, zu dem die im Geothesaurus vorhandenen räumlichen Einheiten ausgegeben und ausgewählt werden können.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(230, 0, 8009, -1, 'de', 'Feldeinstellungen', 'Hier kann ausgewählt werden, ob ein Feld beim ersten Öffnen eines Objekt sichtbar ist oder man es erste ausklappen muss.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(231, 0, 8010, -1, 'de', 'Folgende Felder auch in der Standard-Ansicht anzeigen', 'Liste aller Felder des Katalogs mit der entsprechenden Auswahl der Ansicht (sofort sichtbar oder erst nach dem Ausklappen)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(232, 0, 8011, -1, 'de', 'Nutzeradministration', 'Hier können Nutzer administriert werden, die mit dem Metadaten-Editor arbeiten dürfen. Über das Hinzufügen einer Gruppe, erhält der Nutzer seine entsprechenden Rechte für das Arbeiten mit dem Katalog. Es können nur neue Nutzer hinzugefügt werden, die im Portal schon angelegt wurden und bisher noch keine Rechte für den Editor haben. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(233, 0, 8012, -1, 'de', 'Nutzerdaten', 'Hier können Details zum entsprechenden Nutzer geändert oder geprüft werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(234, 0, 8013, -1, 'de', 'Login', 'Login-Name des entsprechenden Nutzers. Entspricht dem Namen welcher im Portal angegeben wurde.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(235, 0, 8014, -1, 'de', 'Rolle', 'Die Rolle des Nutzers wird über die Portaladministration vergeben und hier nur angezeigt. Möglich sind Katalogadministrator, Metadaten-Administrator (mit QS Rechten) und Metadaten-Autor', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(236, 0, 8015, -1, 'de', 'Adressverweise', 'Zuweisung einer Adresse aus dem Katalog - über den Button "Adresse suchen" kann eine Adresse aus dem Katalogbestand ausgewählt werden', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(237, 0, 8016, -1, 'de', 'Gruppe', 'Über die Gruppe werden die Rechte für die Bearbeitung von Objekten oder Adressen in bestimmten Teilbäumen des Katalogs vergeben.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(238, 0, 8017, -1, 'de', 'Gruppenadministration', 'Über die Gruppe werden die Rechte für die Bearbeitung von Objekten oder Adressen in bestimmten Teilbäumen des Katalogs vergeben. Außerdem kann ausgewählt werden ob der Benutzer Objekte und Adressen freigeben darf (Qualitätssichernder).', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(239, 0, 8018, -1, 'de', 'Gruppendaten', 'Eingabe eines Namens für eine neue Gruppe - sollte deren Verantwortung/Funktion erklären', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(240, 0, 8019, -1, 'de', 'Gruppennamen', 'Name der Gruppe - sollte deren Funktion erklären', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(241, 0, 8020, -1, 'de', 'Root-Objekte und - Adressen anlegen', 'Diese Funktion erlaubt es neue Teilbäume auf der gleichen Ebene wie das freigegebene Objekt/Objektbaum bzw. Adressen zu erstellen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(242, 0, 8021, -1, 'de', 'Qualitätssichernder', 'Ein Qualitätssichernder hat das Recht geänderte Objekte freizugeben, so dass sie anschließen über die Portalsuche zu finden sind.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(243, 0, 8022, -1, 'de', 'Berechtigungen für Objekte', 'Hier können Objekte ausgewählt werden, die die Gruppe bearbeiten darf. Teilbaum bedeutet, dass der gesamt Teilbaum unterhalb des ausgewählten Objekts bearbeitet werden kann.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(244, 0, 8023, -1, 'de', 'Berechtigungen für Adressen', 'Hier können Adressen ausgewählt werden, die die Gruppe bearbeiten darf. Teilbaum bedeutet, dass der gesamt Teilbaum unterhalb der ausgewählten Adresse bearbeitet werden kann.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(245, 0, 8024, -1, 'de', 'Berechtigungsübersicht', 'Hier wird angezeigt, welcher Nutzer ein ausgewähltes Objekt bearbeiten darf, welche Rolle er besitzt, ob er den darunterliegenden Teilbaum bearbeiten darf und ob er QS-Rechte besitzt.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(246, 0, 8025, -1, 'de', 'Berechtigungen für Objekte', 'Auswahl eines Objekts, für das alle Nutzer angezeigt werden sollen, die dieses bearbeiten dürfen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(247, 0, 8026, -1, 'de', 'Berechtigungen für Adressen', 'Auswahl einer Adresse, für die alle Nutzer angezeigt werden sollen, die diese bearbeiten dürfen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(248, 0, 8028, -1, 'de', 'Analyse - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(249, 0, 8029, -1, 'de', 'Dubletten - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(250, 0, 8030, -1, 'de', 'Dubletten - Objektname', 'Anzeige des Namens eines in der linken Spalte ausgewählten Objekts', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(251, 0, 8031, -1, 'de', 'Dubletten - Klasse', 'Anzeige der Objekt-Klasse eines in der linken Spalte ausgewählten Objekts', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(252, 0, 8032, -1, 'de', 'Dubletten - Objektbeschreibung', 'Anzeige der Objektbeschreibung eines in der linken Spalte ausgewählten Objekts', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(253, 0, 8033, -1, 'de', 'URL-Pflege - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(254, 0, 8034, -1, 'de', 'URL-Pflege - Markierte URLs durch folgende URL ersetzen', 'Eingabe einer neuen URL, die die in der Tabellen markierten URLs ersetzen soll', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(255, 0, 8035, -1, 'de', 'Auswahl-/ISO-Codelistenpflege - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(256, 0, 8036, -1, 'de', 'Auswahlliste - Auswahllistenpflege', 'Auswahl der zu prüfenden Auswahl- oder ISO-Codeliste', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(257, 0, 8037, -1, 'de', 'Defaultwert einstellbar', 'Auswahl, ob und welcher Eintrag der Liste per Default angezeigt werden soll d.h. als erster in der Auswahlbox sichtbar ist', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(258, 0, 8038, -1, 'de', 'Auswahlliste - Rechtliche Grundlagen', 'Bearbeitung der Auswahlliste "rechtliche Grundlage" - keine Auswahl einer anderen Liste möglich', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(259, 0, 8039, -1, 'de', 'Zusätzliche Felder - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(260, 0, 8040, -1, 'de', 'Zusätzliche Felder - Feldname', 'Eingabe eines Namens für ein neues, zusätzliches Feld', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(261, 0, 8041, -1, 'de', 'Zusätzliche Felder - Länge', 'Angabe der Länge des Textfeldes - auch bei Auswahllisten kann Nutzer zus. Einträge vornehmen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(262, 0, 8042, -1, 'de', 'Zusätzliche Felder - Typ', 'Auswahl des Typ des neuen Zusatzfelds  - einfaches Textfeld oder Auswahl-Liste mit mehreren Einträgen möglich', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(263, 0, 8043, -1, 'de', 'Adresse löschen - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(264, 0, 8044, -1, 'de', 'Adresse löschen - Titel', 'Anzeige des Namens des im Hierarchiebaum ausgewählten Adressobjekts', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(265, 0, 8045, -1, 'de', 'Adresse löschen - Erstellt am', 'Anzeige des Erstellungsdatums des im Hierarchiebaum ausgewählten Adressobjekts', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(266, 0, 8046, -1, 'de', 'Adresse löschen - Verantwortlicher', 'Anzeige des Verantwortlichen des im Hierarchiebaum ausgewählten Adressobjekts', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(267, 0, 8047, -1, 'de', 'Adresse löschen - ID', 'Anzeige der Objekt-ID des im Hierarchiebaum ausgewählten Adressobjekts', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(268, 0, 8048, -1, 'de', 'Adresse löschen - Qualitätssichernder', 'Anzeige des QS-Beauftragten für das ausgewählte Adressobjekt', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(269, 0, 8049, -1, 'de', 'Adresse löschen - Neue Adresse -Titel ', 'Anzeige des Namens des im Hierarchiebaum ausgewählten Adressobjekts', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(270, 0, 8050, -1, 'de', 'Adresse löschen - Neue Adresse - Erstellt am', 'Anzeige des Erstellungsdatums des im Hierarchiebaum ausgewählten Adressobjekts', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(271, 0, 8051, -1, 'de', 'Adresse löschen - Neue Adresse - Verantwortlicher', 'Anzeige des Verantwortlichen des im Hierarchiebaum ausgewählten Adressobjekts', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(272, 0, 8052, -1, 'de', 'Adresse löschen - Neue Adresse - ID', 'Anzeige der Objekt-ID des im Hierarchiebaum ausgewählten Adressobjekts', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(273, 0, 8053, -1, 'de', 'Adresse löschen - Neue Adresse - Qualitätssichernder', 'Anzeige des QS-Beauftragten für das ausgewählte Adressobjekt', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(274, 0, 8054, -1, 'de', 'Suchbegriffe - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(275, 0, 8055, -1, 'de', 'Suchbegriffe - Aktualisierungs-Datensatz auswählen', 'Auswahl einer lokalen Datei mit aktualisierten Thesaurusdaten', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(276, 0, 8056, -1, 'de', 'Raumbezüge - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(277, 0, 8057, -1, 'de', 'Raumbezüge - Aktualisierungs-Datensatz auswählen', 'Auswahl einer lokalen Datei mit aktualisierten Raumbezugsdaten', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(278, 0, 8058, -1, 'de', 'Allgemeine Einstellungen - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(279, 0, 8059, -1, 'de', 'Allgemeine Einstellungen - Allgemeine Einstellungen', 'Verhalten für automatisches Speichern und für automatische Session-Erneuerung einstellen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(280, 0, 8060, -1, 'de', 'File Dialog - Datei auswählen', 'Auswahl der lokalen XML-Importdatei (Import aller Codelisten)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(281, 0, 8061, -1, 'de', 'GetCapabilities Assistent - Capabilities URL', 'Eintrag der getCapability-URL des entsprechenden Dienstes', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(282, 0, 8063, -1, 'de', 'Allgemeiner Erfassungsassistent - URL der Internetseite', 'Eintrag der URL, der zu analysierenden Internetseite', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(283, 0, 8064, -1, 'de', 'Allgemeiner Erfassungsassistent - Anzahl der zu analysierenden Wörter', 'Angabe der max. Anzahl der zu analysierenden Wörter - Ändert die Dauer der Analyse', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(284, 0, 8065, -1, 'de', 'Allgemeiner Erfassungsassistent - Zeige die Beschreibung der übergebenen Webseite an', 'Optionale Analyse des Meta-Tags "description" der angegebenen Webseite', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(285, 0, 8066, -1, 'de', 'Allgemeiner Erfassungsassistent - Titel übernehmen', 'Auswahl, ob Titel für neues Datenobjekt übernommen werden soll (Meta-Tag "title")', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(286, 0, 8067, -1, 'de', 'Allgemeiner Erfassungsassistent - Beschreibung übernehmen', 'Auswahl, ob Beschreibung für neues Datenobjekt übernommen werden soll (Meta-Tag "description")', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(287, 0, 8068, -1, 'de', 'Allgemeiner Erfassungsassistent - Inhalt der Webseite übernehmen', 'Auswahl, ob die ersten Zeilen des Textes der Webseite als Beschreibung des Objektes übernommen werden sollen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(288, 0, 8069, -1, 'de', 'Allgemeiner Erfassungsassistent - Deskriptoren', 'Auswahl, welche der vorgeschlagenen Deskriptoren zur Verschlagwortung des Objekts übernommen werden sollen. Durch einen Doppelklick in die erste Spalte der Tabelle, kann über eine Checkbox der zu übernehmende Begriff ausgewählt werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(289, 0, 8070, -1, 'de', 'Allgemeiner Erfassungsassistent - Alle Deskriptoren auswählen', 'Auswahl, ob alle angegebenen Descriptoren übernommen werden sollen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(290, 0, 8071, -1, 'de', 'Allgemeiner Erfassungsassistent - Geothesaurus-Raumbezug', 'Auswahl, welche der vorgeschlagenen räumlichen Begriffe in den Raumbezug des Objekts übernommen werden sollen. Durch einen Doppelklick in die erste Spalte der Tabelle, kann über eine Checkbox der zu übernehmende Begriff ausgewählt werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(291, 0, 8072, -1, 'de', 'Allgemeiner Erfassungsassistent - Alle Raumbezüge auswählen', 'Auswahl, ob alle vorgeschlagenen Raumbezüge verwendet werden sollen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(292, 0, 8073, -1, 'de', 'Allgemeiner Erfassungsassistent - Zeitbezug', 'Auswahl, welche der vorgeschlagenen Zeitbezüge in das Objekt übernommen werden sollen. Durch einen Doppelklick in die erste Spalte der Tabelle, kann über eine Checkbox der zu übernehmende Zeitbezug ausgewählt werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(293, 0, 8074, -1, 'de', 'Import - Import-Datei', 'Auswahl einer lokalen Datei mit zu importierenden Datensätzen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(294, 0, 8075, -1, 'de', 'Import - Importierte Datensätze veröffentlichen', 'Auswahl, ob neue Datensätze direkt veröffentlicht werden sollen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(295, 0, 8076, -1, 'de', 'Import - Importierte Datensätze ausschließlich unter dem gewählten Importknoten anlegen', 'Auswahl, ob importierte Datensätze nicht an evtl. vorhandener ehemaliger Position eingefügt werden sollen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(296, 0, 8077, -1, 'de', 'Import - Ausgewähltes übergeordnetes Objekt', 'Auswahl eines Eltern-Objekt, unter das die import. Objekte eingehängt werden sollen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(297, 0, 8078, -1, 'de', 'Import - Ausgewählte übergeordnete Adresse', 'Auswahl eines Eltern-Adresse, unter die die import. Adressen eingehängt werden sollen', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(298, 0, 8079, -1, 'de', 'Import - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(299, 0, 8080, -1, 'de', 'Export - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(300, 0, 8081, -1, 'de', 'Export - Teilexport', 'Export von Datensätzen, bei denen der ausgewählten Begriff im Feld "xml-Export-Kriterium" steht', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(301, 0, 8082, -1, 'de', 'Export - Teilbaumexport', 'Export aller Datensätze des ausgewählten Teilbaums. Geben Sie den Knoten ein, ab dem Sie exportieren möchten.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(302, 0, 8083, -1, 'de', 'Export - Nur der ausgewählte Datensatz', 'Export nur des ausgewählten Datensatzes', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(303, 0, 8084, -1, 'de', 'Zusätzliche Felder - Auswahlliste bearbeiten', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(304, 0, 8085, -1, 'de', 'Import - Teilbaumimport', 'Für einen Teilbaumimport ist immer die Angabe eines Ausgewählten übergeordneten Objekts und einer Ausgewählten übergeordneten Adresse notwendig. Alle noch nicht existierenden Objekte und Adressen werden unterhalb dieser Importknoten abgelegt. Dabei bleibt eine ggf. in der Importdatei mitgelieferte Struktur der Objekte bzw. Adressen erhalten.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(305, 0, 8086, -1, 'de', 'Vergleichsansicht Adressen - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(306, 0, 8087, -1, 'de', 'Vergleichsansicht Objekte - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(307, 0, 8088, -1, 'de', 'Allgemeiner Erfassungsassistent - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(308, 0, 8089, -1, 'de', 'GetCapabilities Assistent - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(309, 0, 8090, -1, 'de', 'File Dialog - Allgemeine Hilfe', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(310, 0, 10006, -1, 'de', 'Geothesaurus-Raumbezug', 'Informationen über die räumliche Zuordnung des in dem Objekt beschriebenen Datenbestand. Über den Geothesaurus-Navigator kann nach den Koordinaten der räumlichen Einheit gesucht werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(311, 0, 10008, -1, 'de', 'Freier Raumbezug ', 'Informationen über die räumliche Zuordnung des in dem Objekt beschriebenen Datenbestand. Es können frei wählbare Raumbezugs-Koordinaten hinzugefügt werden. Der Wertebereich im WGS ist folgendermaßen definiert: <ul><li>Breite (Latitude): -90 bis 90</li><li>Länge (Longitude): -180 bis 180</li></ul>', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(312, 0, 10011, -1, 'de', 'Zeitbezug des Dateninhalts', 'Hier soll das Zeitspanne der Entstehung der eigentlichen Umwelt-Daten (z.B. Messdaten) eingetragen werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(313, 0, 10013, -1, 'de', 'Herstellungszweck', 'Grund für die Datenerhebung', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(314, 0, 10014, -1, 'de', 'Umweltthemen', 'Die Verschlagwortung mit den Begriffen der Umweltbereiche soll dazu dienen, eine Zuordnung der Objekte zu grob eingeteilten Umweltthemen und Kategorien herzustellen. Diese Themen und Kategorien sind in den Auswahllisten enthalten. Es können mehrere Einträge vorgenommen werden. Über das Auswahlfeld "Als Katalogseite anzeigen" kann entschieden werden, ob das Objekt als Katalogseite verwendet werden soll.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(315, 0, 10015, -1, 'de', 'Themen', 'Hier müssen zum Objekt passende  Themenbereiche aus einer Liste ausgewählt werden. Es muss mind. ein Themenbereich ausgewählt werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(316, 0, 10016, -1, 'de', 'Kategorie', 'Hier müssen zum Objekt passende Kategorien aus einer Liste ausgewählt werden. Es muss mind. eine Kategorie ausgewählt werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(317, 0, 10021, -1, 'de', 'Identifikator der Datenquelle', 'Hier muss ein eindeutiger Name (Identifikator) für jede im Datenobjekt beschriebene Datenquelle (z.B. eine Karte) vergeben werden. (INSPIRE-Pflichtfeld)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(318, 0, 10022, 3, 'de', 'Klassifikation des Dienstes', 'Auswahl der Beschreibung des Dienstes. Dieses Feld dient in erster Linie der Identifikation eines Dienstes durch den recherchierenden Nutzer', 'z.B. Katalogdienst, Dienst für geografische Visualisierung, usw. ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(319, 0, 10024, -1, 'de', 'Konformität', 'Hier muss angegeben werden, zu welcher Durchführungsbestimmung der INSPIRE-Richtlinie bzw. zu welcher anderweitigen Spezifikation die beschriebenen Daten konform sind. (INSPIRE-Pflichtfeld)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(320, 0, 10025, -1, 'de', 'Zugangsbeschränkungen', 'Das Feld „Zugangsbeschränkungen“ beschreibt, die Art der Zugriffsbeschränkung. Bei frei nutzbaren Daten bzw. Services soll der Eintrag "keine" ausgewählt werden. Sind die Beschränkungen unbekannt, soll der Eintrag "unbekannt" eingetragen werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(321, 0, 7075, -1, 'de', 'Zusatzfelder', 'Die Zusatzfelder gelten nur katalogweit und werden vom jeweiligen Katalogadministrator zusätzlich zu den Standardfelder des InGridCatalog hinzugefügt.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(322, 0, 10026, -1, 'de', 'Nutzungsbedingungen', 'In das Feld „Nutzungsbedingungen“ sollen die Bedingungen zur Nutzung des beschriebenen Datensatzes bzw. des Services eingetragen werden. Es sollen z.B. die Kosten für die Nutzung der Daten angegeben werden. Bei frei nutzbaren Daten bzw. Services soll „keine Einschränkungen“ eintragen werden. Sind die Bedingungen unbekannt, ist „unbekannte Nutzungsbedingungen“ einzutragen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(323, 0, 3260, 3, 'de', 'Zugang geschützt', 'Das Kontrollkästchen „Zugang geschützt“ soll aktiviert werden, wenn der Zugang zu dem Dienst z.B. durch ein Passwort geschützt ist. Bei aktiviertem Kontrollkästchen wird kein direkter Link („Zeige Karte“) aus dem Portal zu dem Dienst generiert.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(324, 0, 1010, 6, 'de', 'Beschreibung', 'Fachliche Inhaltsangabe des Dienstes, der Anwendung oder des Informationssystems. Hier sollen in knapper Form die Art des Dienstes, der Anwendung oder des Informationssystems sowie die fachlichen Informationsgehalte beschrieben werden. Auf Verständlichkeit für fachfremde Dritte ist zu achten. DV-technische Einzelheiten sollten auf zentrale, kennzeichnende Aspekte beschränkt werden. Das Feld Beschreibungen muss ausgefüllt werden, damit das Objekt abgespeichert werden kann.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(325, 0, 3620, 6, 'de', 'Art des Dienstes', 'In diesem Feld muss die Art des Dienstes ausgewählt werden. Es stehen folgende Einstellungen zur Verfügung: "Informationssystem", "nicht geographischer Dienst" und "Anwendung". Sollte es sich bei Ihrem Dienst um einen geographischen Dienst handeln, wählen Sie bitte in dem dafür vorgesehenen Feld "Objektklasse" die Einstellung  "Geodatenklasse" aus.', '"Informationssystem"; "nicht geographischer Dienst"; "Anwendung"');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(326, 0, 3630, 6, 'de', 'Version', 'Angaben zu Version des beschriebenen Dienstes (Bitte alle Versionen eintragen, die vom Dienst unterstützt werden).', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(327, 0, 3600, 6, 'de', 'Systemumgebung', 'Angaben zum Betriebssystem und der Software, ggf. auch Hardware, die zur Implementierung des Dienstes eingesetzt wird.', 'UMN Mapserver 4.0.2 auf Linux 2.6.0 Für Echtzeit- und near-online-GPS-Anwendungen: Korrekturdatenempfänger Für postprocessing-Anwendungen:GPS-Auswertesoftware');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(328, 0, 3640, 6, 'de', 'Historie', 'Angabe zur Entwicklungsgeschichte. Hier können Vorläufer und Folgedienste bzw. -anwendungen oder -systeme genannt werden. Ebenso sind Angaben zu initiierenden Forschungsvorhaben oder -programmen von Interesse.', '11.12.03: Installation des UMN Mapserver 3.0 auf Linux 2.2.005.04.04: Upgrade Linux 2.2.0 auf Linux 2.6.0 Modellversuch beim Gewerbeaufsichtsamt Osnabrück 1991; Einführung 1993');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(329, 0, 3645, 6, 'de', 'Basisdaten', 'Herkunft und Art der zugrundeliegenden Daten. Im Allgemeinen sind dies die Datensätze, auf die der Dienst aufgesetzt ist. Allgemein sollen die Herkunft oder die Ausgangsdaten der Daten beschrieben werden, die in dem Dienst / der Anwendung bzw. dem Informationssystem benutzt, gespeichert, angezeigt oder weiterverarbeitet werden. Zusätzlich kann die Art der Daten (z. B. digital, automatisch ermittelt oder aus Umfrageergebnissen, Primärdaten, fehlerbereinigte Daten) angegeben werden. Der Eintrag kann hier direkt über die Auswahl der Registerkarte "Text" erfolgen oder es können Verweise eingetragen werden, indem der Link "Verweis anlegen/bearbeiten" angewählt wird.', 'Messdaten von Emissionen in bestimmten Betrieben');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(330, 0, 3650, 6, 'de', 'Erläuterungen', 'Zusätzliche Anmerkungen zu dem beschriebenen Dienst, der Anwendung oder dem Informationssystem. Hier können weitergehende Angaben z. B. technischer Art gemacht werden, die zum Verständnis des Dienstes, der Anwendung, des Informationssystems notwendig sind.', 'Der Datensatz ist eine Shape-Datei, die alle Grundwassermessstellen in Hessen mit Lage und Kennung beinhaltet.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(331, 0, 3670, 6, 'de', 'Service-Urls', 'Angaben zu der Zugriffsadresse auf das Informationssystem, den Dienst oder der Anwendung. Es soll der Name und der URL sowie eine kurzen Erläuterung zu der Adresse angegeben werden.', 'Name: PortalU; URL: http://www.portalu.de; Erläuterung: Umweltportal Deutschland');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(332, 0, 5043, -1, 'de', 'Zeichensatz des Datensatzes', 'Angaben zu dem im beschriebenen Datensatz benutzten Zeichensatz z.B. UTF-8', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(333, 0, 7500, -1, 'de', 'Datenqualität', 'Angaben zur Datenqualität des beschriebenen Datensatzes', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(334, 0, 7509, -1, 'de', 'Datenüberschuss', 'Angaben zu den überschüssigen Features, Attributen oder ihren Relationen; Bsp.: Anzahl der überflüssigen Elemente zur Anzahl der gesamten Elemente: 11,2% (ACHTUNG: es wird nur eine Zahl angegeben; KEIN %-Zeichen)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(335, 0, 7510, -1, 'de', 'Datendefizit', 'Angaben zu den fehlenden Elementen; Bsp.: Anzahl der fehlenden Elemente im Datensatz zu der Anzahl der Elemente, die vorhanden sein sollten: 5,3% (ACHTUNG: es wird nur eine Zahl angegeben; KEIN %-Zeichen)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(336, 0, 7512, -1, 'de', 'Konzeptionelle Konsistenz', 'Angaben zu Fehlern bezüglich der Verletzung der Regeln des konzeptionellen Schemas; Bsp.: Anzahl der überlappenden Oberflächen innerhalb des Datensatzes: 23', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(337, 0, 7513, -1, 'de', 'Konsistenz des Wertebereichs', 'Angaben zur Übereinstimmung des Wertebereichs; Angegeben wird die Anzahl der Übereinstimmungen im Verhältnis zur Gesamtmenge der Elemente', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(338, 0, 7514, -1, 'de', 'Formatkonsistenz', 'Angaben darüber, wie viele Elemente sich im Konflikt zu der physikalischen Struktur des Datensatzes befinden', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(339, 0, 7515, -1, 'de', 'Topologische Konsistenz', 'Angaben zu topologischen Fehlern, die zwischen verschiedenen Unterelementen des Datensatzes auftreten; Bsp.: Anzahl  fehlender Verbindungen zwischen Unterelementen aufgrund von Undershoots/Overshoots.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(340, 0, 7517, -1, 'de', 'Absolute Positionsgenauigkeit', 'Angabe der Abweichung des Mittelwertes der räumlichen Position der Elemente des Datensatzes zum angenommenen tatsächlichen Wert.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(341, 0, 7520, -1, 'de', 'Zeitliche Genauigkeit', 'Angabe der Anzahl der zeitlich korrekt zugeordneten Elemente zur Gesamtzahl der Elemente', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(342, 0, 7525, -1, 'de', 'Korrektheit der thematischen Klassifizierung', 'Angabe der Anzahl der thematisch falsch klassifizierten Elemente zur Gesamtanzahl der Elemente', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(343, 0, 7526, -1, 'de', 'Genauigkeit nicht-quantitativer Attribute', 'Angabe der Anzahl der inkorrekten nicht-quantitativen Attributwerte im Verhältnis zur Gesamtzahl der Attribute ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(344, 0, 7527, -1, 'de', 'Genauigkeit quantitativer Attribute', 'Angabe der Anzahl der quantitativen Attribute, die inkorrekt sind; Bsp.: Anzahl aller quantitativen Werte,  die nicht mit 95% Wahrscheinlichkeit dem wahren Wert entsprechen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(345, 0, 1315, -1, 'de', 'Kodierungsschema der geographischen Daten', 'Kodierung: Beschreibung des Programmiersprachenkonstrukts (zum Beispiel eine Markup-Sprache wie GML), das die Darstellung eines Datenobjekts in einem Datensatz, in einer Datei, einer Nachricht, einem Speichermedium oder einem Übertragungskanal bestimmt.', 'Geographic Markup Language (GML)');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(346, 0, 10100, -1, 'de', 'Qualitätssicherung - Bearbeitung/Verantwortlich - Objekte deren Raumbezüge aktualisiert werden müssen', 'Anzeige von Objekten und Adressen, deren Raumbezüge veraltet sind und daher überarbeitet werden müssen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(347, 0, 10101, -1, 'de', 'ID', 'Die ID eines Feldes muss eindeutig sein, da ansonsonsten die Daten nicht korrekt zu den Feldern zugeordnet werden können. Beim Hinzufügen eines Feldes wird auf eine eindeutige ID hin geprüft und ggf. eine Fehlermeldung ausgegeben. Eine ID kann aus einer beliebigen Zeichenkette bestehen und sollte einen sinnvollen Namen erhalten. Nachdem die ID einmal vergeben wurde kann diese nicht mehr bearbeitet werden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(348, 0, 10102, -1, 'de', 'Pflichtfeld', 'Wird diese Auswahl aktiviert, so wird das Feld als ein Pflichtfeld behandelt. Es wird dann fett mit einem "*" dargestellt. Außerdem wird beim Veröffentlichen eines Objektes, daraufhin überprüft, ob dieses Feld leer ist. Nur wenn es Daten enthält, kann das Objekt dann veröffentlicht werden. Die Sichtbarkeit wird automatisch auf "sichtbar" gesetzt, da Pflichtfelder immer angezeigt werden sollen. Wenn die Auswahl deaktiviert ist, so wird dieses Feld als optional angenommen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(349, 0, 10103, -1, 'de', 'Sichtbarkeit', 'Es gibt verschiedene Optionen, die die Sichtbarkeit eines Feldes beeinflussen. <dl><dt>optional</dt><dd>Initial ist das Feld ausgeblendet und wird erst durch das Ausklappen der dazugehörigen Rubrik sichtbar.</dd><dt>anzeigen</dt><dd>Das Feld wird immer angezeigt, auch wenn die Rubrik eingeklappt ist. Dies ist die Standardeinstellung für Pflichtfelder.</dd><dt>verstecken</dt><dd>Das Feld wird permanent ausgeblendet, wodurch auch keine neuen Daten für dieses Feld aufgenommen werden können.</dd></dl>', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(350, 0, 10104, -1, 'de', 'Beschriftung', 'Hier wird die Beschriftung des Feldes angegeben. Diese kann in verschiedenen Sprachen angegeben werden, wobei die Erste (normalerweise Englisch) angegeben werden muss! Wird der InGrid-Editor in einer Sprache ausgeführt, wo es keine Beschriftung zum Feld gibt, so wird hier die Standardsprache (Englisch) verwendet.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(351, 0, 10105, -1, 'de', 'Hilfetext', 'Hier wird die Hilfetext des Feldes angegeben, welcher durch ein Klick auf die Beschriftung angezeigt wird. Diese kann in verschiedenen Sprachen angegeben werden, wobei die Erste (normalerweise Englisch) angegeben werden muss! Wird der InGrid-Editor in einer Sprache ausgeführt, wo es keinen Hilfetext zum Feld gibt, so wird hier die Standardsprache (Englisch) verwendet.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES
(352, 0, 10106, -1, 'de', 'Skripte', 'In diesem Bereich ist es möglich, zusätzlich JavaScript Code beim Starten des InGrid-Editors auszuführen. Dieser kann dazu dienen, dass ein Feld bspw. auf spezielle Ereignisse reagiert oder die funktionsweise des Feldes sogar erweitert.<br/>Unter dem IDF-Mapping wird der Code in JavaScript hinterlegt, welcher für die Abbildung des Feldes in das Ingrid-Daten-Format benötigt wird.', '// lässt in einer Textbox (mit ID "userEmail") nur gültige Emailadressen zu<br/>dijit.byId("userEmail").regExpGen = dojox.validate.regexp.emailAddress;<br/><br/>// spezielle Überprüfung eines Textfeldes<br/>dijit.byId("doNotAllowNoInTextfield").validator = function(value) {if (value == "NO") return false; else return true;}<br/><br/>// Überprüfung vor einer Veröffentlichung<br/>dojo.subscribe("/onBeforeObjectPublish", function(/*Array*/notPublishableIDs) { if (dijit.byId("aField").get("value")) == "Kein" notPublishableIDs.push("aField");})');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(353, 0, 10107, -1, 'de', 'Optionen', 'Hier werden die Einträge für die Auswahlliste definiert. Die "id" wird automatisch vergeben und wird benötigt, um eine korrekte Zuordnung zu den verschiedenen Sprachversionen eines Listeneintrags zu gewährleisten. Es ist außerdem möglich, die Reihenfolge der Einträge zu verändern, indem man den "Griff" in der ersten Spalte an die gewünschte Position verschiebt.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(354, 0, 10108, -1, 'de', 'Einheit', 'Die Einheit, die hinter der Zahlentextbox angezeigt werden soll. Ist dieses Feld leer, so wird keine Einheit angezeigt.', 'cm, km, Euro');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(355, 0, 10109, -1, 'de', 'Indexname', 'Gibt an, unter welchem Namen dieses Feld im Index abgelegt werden soll. Bleibt dieses Feld leer, so wird dieses Feld auch nicht im Index gespeichert.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(356, 0, 10110, -1, 'de', 'Breite', 'Gibt die Breite des Feldes in Prozent an. 100% gilt für die gesamte Breite, wohingegen 50% die halbe verfügbare Breite in Anspruch nimmt. Werden zwei aufeinanderfolgende Felder mit einer Breite von jeweils 50% angelegt, so werden diese im InGrid-Editor nebeneinander angezeigt. Durch andere prozentuale Verteilungen, lassen sich so auch andere Anordnungen erzeugen.', 'Breite: 100');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(357, 0, 10111, -1, 'de', 'Anzahl der Zeilen', 'Wird ein Textfeld erstellt, so bietet sich die Möglichkeit, die Anzahl der darzustellenden Zeilen zu definieren.', '3');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(358, 0, 10112, -1, 'de', 'Anzahl der Reihen', 'Bei Tabellen wird hier definiert, wieviele Reihen diese Tabelle mindestens anzeigen soll.', 'Default: 4');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(359, 0, 10113, -1, 'de', 'Spaltendefinition', 'Hier können Spalten hinzugefügt oder aber auch gelöscht werden. Die verschiedenen Spaltentypen sind: Textfeld, Nummernfeld, Datum und Auswahlliste. Bei der Erstellung einer Tabelle muss mindestens eine Spalte angegeben werden!', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(360, 0, 10114, -1, 'de', 'Erlaube freie Einträge', 'Wird diese Option aktiviert, so kann zu dieser Auswahlliste im InGrid-Editor auch ein freier Eintrag verwendet und abgespeichert werden. Andernfalls kann nur ein Eintrag aus der vordefinierten Liste ausgewählt werden. Die Einträge können in verschiedenen Sprachen angegeben werden, so dass bei der Verwendung einer anderen Sprache im InGrid-Editor sich auch der Listeneintrag an die ausgewählte Sprache anpasst.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(361, 0, 10150, -1, 'de', 'Typ', 'Der Typ des Feldes für diese Spalte. Dieser kann ein Textfeld, Nummernfeld, Datum oder eine Auswahlliste sein.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(362, 0, 10151, -1, 'de', 'ID', 'Die ID der Spalte muss eindeutig innerhalb einer Tabelle sein!', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(363, 0, 10152, -1, 'de', 'Beschriftung', 'Hier wird die Beschriftung der Spalte angegeben. Diese kann in verschiedenen Sprachen angegeben werden, wobei die Erste (normalerweise Englisch) angegeben werden muss! Wird der InGrid-Editor in einer Sprache ausgeführt, wo es keine Beschriftung zur Spalte gibt, so wird hier die Standardsprache (Englisch) verwendet.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(364, 0, 10153, -1, 'de', 'Optionen', 'Hier werden die Einträge für die Auswahlliste definiert. Die "id" wird automatisch vergeben und wird benötigt, um eine korrekte Zuordnung zu den verschiedenen Sprachversionen eines Listeneintrags zu gewährleisten. Es ist außerdem möglich, die Reihenfolge der Einträge zu verändern, indem man den "Griff" in der ersten Spalte an die gewünschte Position verschiebt.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(365, 0, 10154, -1, 'de', 'Breite', 'Gibt die Breite der Spalte in Pixeln an.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(366, 0, 10155, -1, 'de', 'Indexname', 'Gibt an, unter welchem Namen diese Spalte im Index abgelegt werden soll. Bleibt dieses Feld leer, so wird diese Spalte auch nicht im Index gespeichert.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(367, 0, 10156, -1, 'de', 'Erlaube freie Einträge', 'Wird diese Option aktiviert, so kann zu dieser Auswahlliste im InGrid-Editor auch ein freier Eintrag verwendet und abgespeichert werden. Andernfalls kann nur ein Eintrag aus der vordefinierten Liste ausgewählt werden. Die Einträge können in verschiedenen Sprachen angegeben werden, so dass bei der Verwendung einer anderen Sprache im InGrid-Editor sich auch der Listeneintrag an die ausgewählte Sprache anpasst.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(370, 0, 8174, -1, 'de', 'Import-Type', 'Es gibt drei verschiedene Formate die importiert werden können:\n\nInGrid Catalog: Der Import erfolgt im gleichen Format wie der Export.\n\nCSW 2.0.2 AP ISO 1.0 (Single Metadata file / ZIP Archive): Die Importdateien müssen gültige XML-Dokumente im OGC-Format des Catalog Service Web (CSW) in der Version 2.0.2 und nach Definition des Application Profile ISO 1.0 bestehen. Dabei kann eine XML Datei oder ein ZIP Archiv importiert werden, in dem XML Datein ohne Pfadangaben verpackt wurden.\n\nArcGIS ISO-Editor (Single Metadata file / ZIP Archive): Import von mit Hilfe von ArcGIS erzeugten XML-Dateien. Die Dokumente müssen aus ArcGIS heraus im ISO-Format gespeichert worden sein. Es kann eine XML Datei oder ein ZIP Archiv importiert werden, in dem XML Datein ohne Pfadangaben verpackt wurden.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(371, 0, 7076, -1, 'de', 'Qualitätssicherung - Bearbeitung/Verantwortlich - Objekte deren Raumbezüge aktualisiert werden müssen', 'Anzeige von Objekten und Adressen, deren Raumbezüge veraltet sind und daher überarbeitet werden müssen.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1001, 0, 1000, -1, 'en', 'Addresses', 'Input of address references to persons or institutions, which can provide further information on the current object. If needed, these references can be amended. In the first column the type of reference is entered respectively (information, data holder etc.). The reference is itself created via the "add address" link. All the persons already entered in the address manager of the current catalogue are available for selection. Making an entry in the first line (information) is obligatory. ', 'Information / Sam Sample Data Holder / Jane Sample');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1002, 0, 1010, 3, 'en', 'Description', 'Technical contents of the Geo-Service. Here the type of the Service as well as the technical information contents is to be described. Care should be taken over comprehensibility for none specialists. Technical IT details should be limited to central, characteristic aspects. The descriptions field must be filled in so that the object can be saved.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1003, 0, 1010, 0, 'en', 'Description', 'Technical description of the Organisational Unit / Task. In the case of an organisational unit the significant areas of Organisational Unit / Task are to be listed and, where necessary, explained in brief. In doing so the specialist tasks of the organisational unit should be at the forefront. If the object has been set up to describe a single specialist task then this specialist task should be explained further (legal basis, organisational parameters, target-setting and, where necessary, any overlapping with other specialist tasks). Care should be taken over comprehensibility also for none specialists. The descriptions field must be filled out so that the object can be saved.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1004, 0, 1010, 4, 'en', 'Description', 'Technical contents of the Enterprise / Project / Program. This is where the target-setting and most important parameters of the Enterprise / Project / Program are to be described briefly. Care should be taken over comprehensibility also for none specialists. Separate entry fields are available for detailed information (name of the project leader, those participating in the project, etc.). The descriptions field has to be filled in so that the object can be saved.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1005, 0, 1010, 5, 'en', 'Description', 'Technical description of the Data Pooling / Data Base. Here the main contents of the Data Pooling / Data Base are to be briefly described. In doing so one should restrict oneself to parameter groups (e.g. heavy metals). Detailed parameters can be entered in a separate field (see relevance). Furthermore, where necessary, the organistional frameworks of the data collection/ data base are of interest (history, maintenance, user circle, cooperations). Care should be taken over comprehensibility also for none specialists. The descriptions field has to be filled in so that the object can be saved. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1006, 0, 1010, 2, 'en', 'Description', 'Contents information on the Document / Report / Literature. A short but informative statement of contents (abstract) is to be entered. This contents statement can, for example, contain the starting point for an investigation, possible methods for proceeding as well as the main results. Care should be taken over comprehensibility also for none specialists. There are separate entry fields available for detailed information (author, publication year, etc.). The description field must be filled in so that the object can be stored. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1007, 0, 1010, 1, 'en', 'Description', 'Technical contents information of the Geoinformation / Map. Here there should be a short description of what kind of geographical information it is: GIS data, analogue map, collection of maps, topographical map, political map, thematic map, etc. in addition the main contents of the factual information represented should be mentioned (e.g. stream gauging station, coal-fired power station). Care should be taken over comprehensibility also for none specialists. Separate input fields are available for detailed information (scales, etc.). The descriptions field must be filled in so that the object can be saved.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1008, 0, 1020, -1, 'en', 'Object class', 'Allocation of the object to a suitable information category. In the Metadata Editor the different types of information are arranged into information categories (socalled object classes). The object classes are distinguished by different description fields in the relevance register card. One of the following object classes must be selected: - Data Pooling / Data Base: analogue or digital collection of data. Examples: readings, statistical surveys, model data, data on plants - Service / Application / Information System: central information sytems, which as a rule access one or several data banks and make these accessible - Document / Report / Literature: prospectuses, books, essays, expert opinion, etc. Of interest in particular are documents which are not available through bookshops or libraries ("grey literature") ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1009, 0, 1030, 0, 'en', 'Responsible user', 'Input of address links for persons or institutions who are responsible for this object. ', '"Sample, Erica"');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1010, 0, 1130, -1, 'en', 'Minimum', 'Details of the values for the height above a point (see flow) entered. If a vertical extention exists then a larger value can be entered for the maximum. Should this not be the case then entering a minimal value is sufficient, this value will then autmatically be used for the maximum value as well. ', 'Minimum 100, Maximum 110');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1011, 0, 1140, -1, 'en', 'Comment', 'Additional details on spatial reference. ', 'The coordinates for the technical areal unit are approximate data.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1012, 0, 1220, -1, 'en', 'State', 'Status of the project', 'completed');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1013, 0, 1230, -1, 'en', 'Interval', 'Information aboutthe time intervals (frequency) of the data collection. Whether the data collection takes place continuously or periodically (see periodicity field), this detail should be specified here. There are fields available for the free input of a number and a drop down list to specify the time intervals. Entering 10 and days means: The data described are, or were, collected every 10 days.', 'Every 6 months');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1014, 0, 1240, -1, 'en', 'Periodicity', 'Statement of the time cycle of the data collection. The entry has to take place from the drop down list which is opened by means of the arrow at the end of the field. The entry "unknown" should no longer be used and, should it still be present in old data, it should be replaced by meaningful entries. It represents an expansion of the drop down list that it is not ISO-compliant. ', 'Daily');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1015, 0, 1250, -1, 'en', 'Description', 'Additional details on the time reference. This is where, for example, the details on periodicity can be restricted, further time details given or irregularities explained. In connection with the entry in the periodicity field, this is where spacing, periods and intervals are entered that are not self-explanatory from the other time reference fields, e.g. seasons, decades, times of the day.', 'The measurements were only taken in the daytime.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1016, 0, 1310, -1, 'en', 'Media Option', 'Statement on which media the data can be made available. This is where electronic data storage media as well as media in paper form can be given on which the data described in the object are available to the user. Several media can be entered. Medium: statement of the media on which the data set can be made available (ISO drop down list); Volume: size of the data volume in MB (floating point number); Location: location of the data storage in the intranet/internet, enter the link', 'Medium: CD-ROM; Volume: 700 MB; Location: Explorer Z:/Area_51/Metainformation/20040423_Helptexts.doc');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1017, 0, 1320, -1, 'en', 'Data Format', 'Technical details on the format of the data in which it is available. The format is specified through 4 different entries. When the first column is filled the other entries also have to be made. Name: detail of the format name, such as, for example, "Date"; Version: Version of the data available (e.g. "Version 8" or "Version of 8.11.2001"); Compression: compression technology in which the data are delivered (e.g. "Zip", "none"); Depth: BitsPerSample.', 'Name: tif; Version: 6.0; Compression: LZW; Depth: 8 Bit');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1018, 0, 1350, -1, 'en', 'Legal Basis', 'Details of the legal basis that has instigated the collection of the data described. Here abbreviations for laws, decrees, ordinances etc. can be entered, in which, e.g., the method or the form of the collection of the data described in the object is set down or described. If needed, more than one entry can be made. ', 'Lower Saxony');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1019, 0, 1360, -1, 'en', 'Description', 'Statement why the data were collected.', 'Topographical maps are being produced to document the land area.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1020, 0, 1370, -1, 'en', 'XML-Export-criteria', 'Entry of a selection criterion to control the export of the data. In order to be able to export a subset of objects, a keyword designating this subset can be entered in this field. Then, in the export function one of the keywords from this field can be given and all objects are exported for which the corresponding keyword was given in this field. Entering of more than one keyword is possible. The keywords can be freely entered. To prevent typing errors entries should be taken from the drop down list. ', 'CDS');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1021, 0, 1410, -1, 'en', 'Add Free Optional Topics', 'Entering keywords by means of which the object can be found with optimum speed during a keyword search and which are not in the thesaurus. Succinct concepts and terms should be entered, which are closely connected with the object but which are not in the thesaurus. These can be specific subject areas, (measurement methods, component parts or similar). Free search terms are to be given to complement the thesaurus search terms. If you enter a thesaurus term it will be automatic identified and marked as a thesaurus term. ', 'Inventory record; Raster map; Moths');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1022, 0, 1420, -1, 'en', 'Optional Topics', 'Entering of at least three keywords if possible, which are listed in the thesaurus. Providing keywords helps the topic-based retrieval of objects via Thesaurus Navigator. For this keywords have to be selected from the thesaurus that describe the object as precisely as possible but also as broadly as necessary. This way at least one keyword in the thesaurus hierarchy will describe a relatively general aspect of the object and at least one keyword will desribe the object as specifically as possible. Selection can be done via the "keywording assistant" or "Thesaurus Navigator" - see link.', 'Nature conservation; Butterfly; Mapping; Species protection');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1023, 0, 1500, -1, 'en', 'Links To', 'There is the possibility of creating references from one object to another object or to a www-address (URL). In this table all references are listed that were created in the current object as a summary. A dialogue box opens via the link "create/edit references" with which further details on the references can be viewed and edited. Additionally, it is possible to add further references via this dialogue box.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1024, 0, 1510, -1, 'en', 'Links From', 'In this table all references are listed from those objects that refer to the current object. Editing or adding to them is not possible. Shall references be deleted or added,to the corresponding object must be changed.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1025, 0, 2000, -1, 'en', 'Link Name', 'Statement of the technical relationship that exists between the current object and the reference object (other object, URL). The relationship of the reference created should be described briefly and succinctly here (e. g. data collection for the report, literature reference for data collection). A description that has already been used can be adopted from a drop down list. This field is only editable if a new reference is produced or an older one is called up. A meaningful name for the reference should be entered. If the dialogue box is opened from a field in another register card then the relevant field name is automatically entered and displayed (e.g. technical documentation). ', 'Literature reference for the V-model');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1026, 0, 2100, -1, 'en', 'Object Name', 'Object name of the object to which is being referred. The reference to an object can be formed independently of structure tree and hierarchy for technical reasons. The entry is done via a selection from the structure tree that can be opened via the "Select Object" link.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1027, 0, 2110, -1, 'en', 'Description', 'Comments to the link. This is where further information on the object can be entered. Explanations on the connection between the data described on the current object and the data of the object referred to can be given. ', 'The object referred to contains further references on the current object. ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1028, 0, 2200, -1, 'en', 'Internet-Address (URL)', 'Input of the internet address. This is where URLs are to be entered under which data or an application to be found, which are closely connected to the data described or where the data can be viewed in the internet. ', 'http://www.regionalauthority.germanland.de/ozonedata.html');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1029, 0, 2210, -1, 'en', 'Link Description', 'Entry of a meaningful descriptor for the reference. For example, the self-documenting name of the website can be entered. ', 'Technical documentation on the air monitoring system of Lower Saxony (L');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1030, 0, 2220, -1, 'en', 'Data Size', 'Information on the size of the data involved under the particular URL. Information is to be given here on the approximate quantity of the data that will be transferred when calling up the URL. The entry is to be made in MB or KB.', '120 MB');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1031, 0, 2230, -1, 'en', 'Icon-Text', 'Text, which is displayed instead of an icon when the browser setting don', 'NUMIS');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1032, 0, 2240, -1, 'en', 'Data Type (dialogue box link)', 'Information on the data format ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1033, 0, 2250, -1, 'en', 'Icon-URL', 'Input of a URL, which is representing the data referenced. An application or data is often characterised by a significant icon. In this field the internet address is to be given where this icon is to be found.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1034, 0, 2251, -1, 'en', 'URL Type', 'Here a distinction can be made whether this URL applies to the internet or to the intranet.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1035, 0, 2260, -1, 'en', 'Description', 'Notes on the link. This is where further information on the URL can be entered. Explanations on the connection between the data described on the current object and the data of the reference object can be made. ', 'Java-Applets are loaded.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1036, 0, 2300, -1, 'en', 'Link Description', 'Entry of a meaningful description for the reference. For example, if a text document is inserted as an OLE-Object, then the title of this document can be entered.', 'Technical Documentation on the Air Monitoring System of Lower Saxony (L');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1037, 0, 3000, 3, 'en', 'Object Name', 'Denotation which gives a brief, succinct description of the Geo-Service being described. The object name can, for example, be identical with the name of the Geo-Service as long as this is sufficiently brief and meaningful.  Where there is an abbreviation in common use then this abbreviation is to be given as well. Making an entry in this field is obligatory.', 'Remote Monitoring of Emissions RME');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1038, 0, 3000, 0, 'en', 'Object Name', 'Denotation which gives a short, succinct description of the organisational unit or task being described. ', 'Annual statistics on the status of the contaminated site management.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1039, 0, 3000, 4, 'en', 'Object Name', 'Denotation which gives a short, succinct description of the Enterprise / Project / Program being described. The name of the object can, for example, be identical with the title of the enterprise, project or program if this is sufficiently short and meaningful. If there is an abbreviation in common use then this abbreviation is also to be given. This field is obligatory.', 'Moors conservation programme');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1040, 0, 3000, 5, 'en', 'Object Name', 'Denotation which gives a short, succinct description of the Data Pooling / Data Base described. The object name can, for example, be identical with the name of the data bank and/or the data collection if this is short and succinct. If there is an abbreviation in common use then this abbreviation is also to be given. This field is obligatory.', 'Anion Concentration in Waste Water');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1041, 0, 3000, 2, 'en', 'Object Name', 'Denotation which gives a short, succinct description of the Document / Report / Literature being described. The name of the object can, for example, be identical with the title of the document, report or literature if this is sufficiently short and meaningful. If an abbreviation is in common use then this abbreviation is also to be given. This field is obligatory.', 'Heavy Metal Contamination of the Ground in Landfill Vicinity before 1950');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1042, 0, 3000, 1, 'en', 'Object Name', 'Denotation which gives a short, succinct description of the map or geo-information being described. The name of the object can, for example, be identical with the name of the map or of the geo-information if this is sufficiently short and meaningful. If an abbreviation is in common use then this abbreviation is also to be given. This field is obligatory.', 'Biotop type map');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1043, 0, 3100, 5, 'en', 'Method', 'Statement of the methods used and the source of the data. This is where the methods used for obtaining the data (e.g. measurement method, method of collecting the data) are to be named and described. In addition, statements can be entered, for example, on the quality or scope of the base data. The entry can be made as soon as the register card ', 'Ion chromatograph as per DIN 38405-D20 (Sept. 91)');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1044, 0, 3110, 5, 'en', 'Content', 'Listing of the most important parameters of the data bank and/or data collection. Here the meaningful parameters of the data provided are to be named to obtain a qualified insight into the data collection or database described. These parameters are entered in the left column. Examples of parameters: in the case of readings, the most important measurement parameters (e.g. NOx, SO2, windspeed, pH-value), in the case of statistical surveys, the size of the surveys (e.g. water consumption per head, population density ) in the case of model data, the model parameters (e.g. sea level, CO2 content of the air, global temperature) are given. In the right column details can be given for each parameter to expand. For example, details on the unit of measurement, accuracy, limit of detection, probe matrix or parameter-specific details on the method of measurement used come to mind.', 'Lead / in drinking water, limit of detection: 10 ppb cadmium / in slag, limit of detection: 3 ppm');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1045, 0, 3120, 5, 'en', 'Description', 'Additional details on the data collection or the database', 'The stated contents of the data bank only represent a selection of all parameters measured (approx. 300 in all)');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1046, 0, 3200, 3, 'en', 'Environment', 'Details on the operating system, the software and, where applicable, hardware used to carry out the service.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1047, 0, 3210, 3, 'en', 'General', 'Origin and type of the underlying data. With an OGC web service, references to one or several objects can be inserted that are tightly coupled with this service. In general, these are the data sets on which the service is based. For this, if possible, please use a "reference to service", which is entered in the object describing the base data (class Geoinformation / Map). In general, the origin or the start data of the data are described, which are used in the service. In addition, the type of the data (e.g. digital, automatically produced or taken from survey results, primary data, error-adjusted data). The entry here can take place directly via the selection of the "text" register card or references can be entered by selecting the link "Add/Edit Link".', 'Readings for emissions in certain firms and/or the insertion of a reference to the "tightly coupled" OGC web service.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1048, 0, 3220, 3, 'en', 'Type of Service', 'Within this mandatory field you can choose the type of the service. The input of this field controls the information that has to be provided for the ', 'View Service; Download Service; Discovery Service');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1049, 0, 3230, 3, 'en', 'Service Version', 'Details on the version of the underlying base specification of the service. Please enter all versions supported by the service.', '1.1.1; 2.0');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1050, 0, 3240, 3, 'en', 'History', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1051, 0, 3250, 3, 'en', 'Description', 'Additional explanatory notes on the service described. Here it is possible to give further information, e.g. of technical nature, necessary for the understanding of the service. ', 'The data set is a shape file which contains all ground water measuring locations in Hessen with position and designator. ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1052, 0, 3300, 2, 'en', 'Publish Year', 'Detail concerning the year of the publication of the literature. The year of publication is extremely important for identification purposes above all for literature that appears regularly such as, for example, annual conference proceedings. The year of publication can differ from the corresponding details in the time reference of the object that refer to the contents of the literature and not to the literature itself. ', '1996');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1053, 0, 3310, 2, 'en', 'Publish Location', 'Information about the place of publication of the literature. This information relates to the literature and not to the contents of the literature. The spatial mapping of the contents of the literature is done in the details on the spatial reference of the current object. ', 'Hamburg');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1054, 0, 3320, 2, 'en', 'Pages', 'Information on the number of pages in the literature. Here the number of the pages is to be stated if it is a book. For an article that has appeared in a periodical, then the page numbers of the start of the article and of the end should be given. ', '345; 256-268');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1055, 0, 3330, 2, 'en', 'Issue', 'Statement of the numbering of the volume concerned in a series. Periodicals and part works or series have consecutive numbering from publication or per year. Here the numbering of the volume is to be given, in which the article or report has appeared.', 'Volume IV');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1056, 0, 3340, 2, 'en', 'Published In', 'Detail of the part work in which an essay has appeared. Essays and other non-stand-alone literature have often appeared as part of a periodical or of a book or as the printed version of a lecture within the framework of a conference. Here one should give the title of the periodical or the part work (conference proceedings, annual reports etc.), in which the literature described has appeared. An article can be sourced from the publisher under this title. ', 'Annual reports on waste management');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1057, 0, 3345, 2, 'en', 'General', 'Reference to underlying base data. Here references to other objects in this catalogue should be given, which give information about the origin and the type of the underlying base data. Using the register card ', 'Berlin-Tegel Landfill Monitoring, Statistical evalustions since 1974');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1058, 0, 3350, 2, 'en', 'Publisher', 'Detail of the publisher. The publisher is, for example, the institution in which an author works and by whom he was commissioned. It can also be a publishing house, a society or other incorporation that collects articles on a subject and publishes them in a book or books on a topic in a series.', 'Federal Environment Agency');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1059, 0, 3355, 2, 'en', 'Author', 'Details of the author and/or editor of the literature. When entering several persons, a semi-colon is to be used to separate them.', 'Jane Sample; Sam Sample');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1060, 0, 3360, 2, 'en', 'Location', 'Details of the depository and possible place for sourcing the literature should sourcing by normal means (bookshops, libraries) not be possible. The entry can be made directly by selecting the "Text" register card or address references can be entered by the register card activating "Link" and the reference "Add Address" being used. Addresses can be searched for first name, surname or name of the unit/institution in the current catalogue. Alternatively the entry can be made via the hierarchy tree. ', 'Library of  the Federal Environment Agency');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1061, 0, 3365, 2, 'en', 'ISBN-No.', 'Specification of the 10-digit identification number of the literature.', '3-456-7889-X');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1062, 0, 3370, 2, 'en', 'Publisher', 'Specification of the publishing house, in which the literature has appeared. ', 'econ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1063, 0, 3375, 2, 'en', 'Description', 'Additional comments on the literature described.', 'The article is based on the PhD thesis of the author from the year 1995 at the University of ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1064, 0, 3380, 2, 'en', 'Additional Bibliographic Data', 'Here bibliographical details can be given, for which no field has been explicitly envisaged. These can, for example, be details on illustrations or on the format. It is also important to note if the document has a diskette or a CD-ROM with it and/or whether it has appeared in identical form on a CD-ROM. ', 'The map book has appeared in DIN A3 format.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1065, 0, 3385, 2, 'en', 'Document Type', 'Details of the type of the document. A short description of the nature of the literature is to be given. The entry can be done directly or with the aid of a drop down list which can be opened by the arrow at the right end of the field. ', 'Magazine article');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1066, 0, 3400, 4, 'en', 'Project Manager', 'Details of the project manager. The entry can be done directly via the selection of the register card "Text" or address references can be selected by activating the "Link"', 'Dr. Antje Robbe');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1067, 0, 3410, 4, 'en', 'Participants', 'Details of persons or institutions that have taken part in the project or in the programme or scheme. The entry should give information on important institutions or persons, who took part or are taking part and from whom possibly further, more precise information is to be learned. The entry can be made directly via the selection of the ', 'Federal Agency for Nature Conservation; Federal Ministry of the Environment');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1068, 0, 3420, 4, 'en', 'Description', 'Further details on the project and/or programme or scheme. Here, additional significant details can be entered, e.g. financing, project funding reference number, processing status. ', 'Financing via Federal Ministry of the Environment, EU');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1069, 0, 3500, 1, 'en', 'Spatial System', 'Specification of the spatial reference systems', 'EPSG:4326 / WGS 84 / geographical');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1070, 0, 3515, 1, 'en', 'Creation Process', 'Detail of the method that led to the creation of the data object. The entry can be done in text form by selecting the "Text" register card. In addition, a reference can be specified by selecting the "Link" register card. ', 'Field Mapping');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1071, 0, 3520, 1, 'en', 'Technical Basis','Details of the documents that are the basis for the technical contents of the map or data collection. In addition, rules for the capture (geo-information) and/or display (map) can be given. This document can represent an explanation of the legal bases but can also stand alone. The entry can be done in text form by selecting the "Text" file card. In addition, by selecting the "Link"', 'Drawing rules');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1072, 0, 3525, 1, 'en', 'Scale', 'Specification of the scale, which refers to the map produced and/or digitalisation basis for geo-data. Scale: scale of the map, e.g. 1:12; Ground Resolution: unit divided by resolution multiplied by the scale (given in metres, floating point number);nScan Resolution: resolution e.g. of a map scanned in, e.g. 120dpi (given in dpi, integers) (optional INSPIRE field)', 'Ground Resolution: resolution unit in lines/cm; unit: e.g. 1 cm divided by 400 lines multiplied with the scale 1:25.000 gives 62.5 cm as ground resolution');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1073, 0, 3530, 1, 'en', 'Position Accuracy', 'Statement on the accuracy e.g. in a map', '0,5 m');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1074, 0, 3535, 1, 'en', 'Key Catalogue', 'In this place there is the possibility of naming the classification keys upon which the data are based. In doing this, the input of several catalogues with the associated date (obligatory entry) and version (optional) is possible. ', 'Type: Biotop type key; Date 01.01.1998; Version 1.1');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1075, 0, 3555, 1, 'en', 'Symbol Catalogue', 'Agreed symbols can be prescribed used for the production of maps to present standardised objects and facts. Giving one or several analogue or digital symbol palettes is possible here with the associated date (obligatory entry) and version (optional).', 'Title: German standard for map symbols; Date: 01.01.1998; Version: 1.0');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1076, 0, 3565, 1, 'en', 'Coverage', 'Input of a percentage for the status of the coverage of the data object. This can relate to the number of map sheets but also to the degree of coverage of an entire map.', '55');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1077, 0, 3570, 1, 'en', 'Data Basis', 'Specification of the documents (aerial photographs, maps, data collections), which find use in the creation of the map or the geo-information (of the digital data inventory). The entry can be done in text form, by selecting the ''Text'' register card. In addition, by selecting the ', 'Mapping originals of the Plant Logging');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1078, 0, 3571, -1, 'en', 'Publication Condition', 'The publication field details which publication possibilities have been allowed for the object. The list of the possibilities has been ordered hierarchically according to release levels. If a lower release level has been dedicated to an object (e.g. from internet to intranet), all the objects subordinate to this will be automatically dedicated to this level. If a higher release level is dedicated to an object than the one dedicated to the subordinate object then the action is rejected. If a higher release level is dedicated to an object (e.g. in-house on intranet), then all the subordinate objects will also be dedicated to the higher release level. ', 'The setting has the following significance: Internet: the object may be published everywhere; Intranet: the object may only be published in the intranet but not in the internet; In-house: the object may only be published as it is created but neither in the internet nor in the intranet. ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1079, 0, 4000, 3, 'en', 'Surname', 'Name of a person (obligatory field), for which a free address is to be entered. Hint: This mask serves for the entering of so-called free addresses of persons. This are addresses that are not hierarchically constructed (institution/unit/person). Entering free addresses make sense if a person cannot be allocated to any institution or if only the address of an single employee of an institution shall be entered. ', 'vom Busche');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1080, 0, 4005, 3, 'en', 'Forename', 'Entry of the first name of the person. In order to avoid confusion between people with the same surnames, the first name of the person entered should be given here. Giving all first names is not important. ', 'Rosemarie');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1081, 0, 4010, 3, 'en', 'Institution', 'Name of the institution the person belongs to. If the work address of the person is to be inserted, this is where the name of the institution the person belongs is to be entered. The unit concerned (department, division, section etc. ) as well can be entered in a further line. ', 'Land Institute for Environmental Protection');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1082, 0, 4015, 3, 'en', 'Form', 'Entry of the Form of the adress. To enable the person entered to be addressed correctly in any correspondence, wrong forms for the person entered should be avoided. The standard entries (Mrs, Mr) are contained in the drop down list. Free entries are however possible (e.g. Frau, Herr).', 'Mrs');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1083, 0, 4020, 3, 'en', 'Title', 'Entry of the academic title of the person. Here the academic titles which precede names should be given. Official titles (e.g. Minister, Undersecretary) should not be given for data protection reasons. ', 'Prof. Dr.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1084, 0, 4100, 0, 'en', 'Institution', 'Name of the institution. Here the full, official designation of the institution should be entered. An institution is an official, independent organisational unit. This can, for example, be an authority, an official institution or a company. In order to specify the persons responsible, units and person can be assigned to the institutions, which then contain detailed statements on the unit and the person. A person can also be directly assigned to an institution. An institution can also be entered on its own, without persons or units assigned, in the address references of the objects. ', 'State Department for the Environment');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1085, 0, 4200, 1, 'en', 'Unit', 'Name of the unit. Here the complete, official designation of the unit is to be entered. A unit represents an organisational subdivision of a superordinate institution. It is possible to arrange one unit under another unit (e.g. section XY under department Z).', 'Section 606 (IT organisation, Environment Information Systems)');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1086, 0, 4210, -1, 'en', 'Superior Institution / Unit', 'The superordinate institution and the superordinate units are displayed.', 'Ministry for  Environment and Climate Protection');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1087, 0, 4300, 2, 'en', 'Form', 'Entry of the Form of the adress. To enable the person entered to be addressed correctly in any correspondence, wrong forms for the person entered should be avoided. The standard entries (Mrs, Mr) are contained in the drop down list. Free entries are however possible (e.g. Frau, Herr).', 'Mrs');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1088, 0, 4305, 2, 'en', 'Title', 'Entry of the academic title of the person. Here the academic titles which precede names should be given. Official titles (e.g. Minister, Undersecretary) should not be given for data protection reasons. ', 'Prof. Dr.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1089, 0, 4310, 2, 'en', 'Forename', 'Entry of the first name of the person. In order to avoid confusion between people with the same surnames, the first name of the person entered should be given here. Giving all first names is not important. ', 'Rosemarie');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1090, 0, 4315, 2, 'en', 'Surname', 'Entry of the surname of the person. The complete surname of the person shiould be entered. ', 'vom Busche');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1091, 0, 4400, 0, 'en', 'Street', 'Entry of the address. With the street and house number of the institution this should be the address of the headquarters and/or the main building. For the units and persons belonging to the institution, their own addresses can be entered. Stating the address is obligatory if no post office box is given. ', '14 Smith Street');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1092, 0, 4400, 2, 'en', 'Street', 'Entry of the address of the building. In giving the street and number of the person, this should be the address of the building where the person works. Giving a building', '14 Smith Street');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1093, 0, 4400, 3, 'en', 'Street', 'Entry of the building address. By the street and building number of the person this means the address of the office building where the person works. Should the entry for the institution be missing then normally the private address is to be entered.  The giving of a building address is obligatory if no post office box is given. ', '14 Smith Street');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1094, 0, 4400, 1, 'en', 'Street', 'Entry of the building address. With the street and number of the unit, it should be the address of the unit', '14 Smith Street');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1095, 0, 4405, 0, 'en', 'Country', 'Entry of the country to which the address belong. A entry from the select list has to be chosen.', 'Germany');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1096, 0, 4410, -1, 'en', 'Post Code', 'Post code of the building address (street/building number). Here the post code referring to the building', '30169');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1097, 0, 4415, 0, 'en', 'City', 'The place is to be given where the headquarters and/or the main building of the institute is to be found. For the units and people assigned, their own addresses and/or location details can be entered.  Should the location for the building address (street/ building number) and post office address (post office box) be different it is enough to enter only one complete address (building or post office address).', 'London');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1098, 0, 4415, 2, 'en', 'City', 'The place is to be given where the office building is located in which the person concerned is employed. For the institution/units assigned then their own addresses and/or location details can be entered. In the case where the place for the building address (street/number) and post office address (post office box) is different it is enough to enter only one complete address (building or postal address).', 'London');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1099, 0, 4415, 3, 'en', 'City', 'The place where the office building, in which the person concerned works, is located is to be given. Should the private address of the person concerned be given, the place of residence is to be given. Where the place for building address (street/number) and postal address (post office box) is different, it is enough to enter only one complete address (building or postal address).', 'London');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1100, 0, 4415, 1, 'en', 'City', 'The place where the unit', 'London');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1101, 0, 4420, -1, 'en', 'P.O. Box', 'Entry of the number of the post office box. To complete the building address here a post office box can be given. If no building address is given then entering a post office box is mandatory so that the address can be saved. For the rare occasion that no building address exists and the post code already represents the number of the post office box (that is, no special post office box number exists) a blank character should be inserted here. ', '30151');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1102, 0, 4425, -1, 'en', 'Post Code (POB)', 'Postcode of the post office box. Here should be entered the postcode that relates to the post office box. A designated field is envisaged for the postcode for the building address (street/number). ', '8977');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1103, 0, 4430, 0, 'en', 'Communication', 'Entries of telephone numbers, fax numbers, e-mail and URL address etc. In this table all means of communication (except for normal post) should be entered by which the institution can be contacted. The communication medium can be entered via a drop down list. In the right column the associated number for telephone or fax and/or address for e-mail communication can be entered. Important: Giving the e-mail address is obligatory! (INSPIRE-mandatory field)', 'E-mail : pressestelle@mu.niedersachsen.de');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1104, 0, 4430, 2, 'en', 'Communication', 'Entries of telephone numbers, fax numbers, e-mail and URL address etc. In this table all means of communication (except for normal post) should be entered by which the person can be contacted. The communication medium can be entered via a drop down list. In the right column the associated number for telephone or fax and/or address for e-mail communication can be entered. Important: Giving the e-mail address is obligatory! (INSPIRE-mandatory field)', 'antje.robbe@mu.niedersachsen.de');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1105, 0, 4430, 3, 'en', 'Communication', 'Entries of telephone numbers, fax numbers, e-mail and URL address etc. In this table all means of communication (except for normal post) should be entered by which the person or institution can be contacted. The communication medium can be entered via a drop down list. In the right column the associated number for telephone or fax and/or address for e-mail communication can be entered. Important: Giving the e-mail address is obligatory! (INSPIRE-mandatory field)', 'antje.robbe@mu.niedersachsen.de');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1106, 0, 4430, 1, 'en', 'Communication', 'Entries of telephone numbers, fax numbers, e-mail and URL address etc. In this table all means of communication (except for normal post) should be entered by which the unit can be contacted. The communication medium can be entered via a drop down list. In the right column the associated number for telephone or fax and/or address for e-mail communication can be entered. Important: Giving the e-mail address is obligatory! (INSPIRE-mandatory field)', 'pressestelle@mu.niedersachsen.de');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1107, 0, 4435, 0, 'en', 'Notes', 'Further details on the institution. Additional relevant information can be entered here for information retrieval. This can, for example, be opening hours or descriptions of how to get there. ', 'Visitors: MON-FRI 9-12 hrs; THU 14-19 hrs');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1108, 0, 4435, 2, 'en', 'Notes', 'Further details on a person', 'Available mornings');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1109, 0, 4435, 3, 'en', 'Notes', 'Further details on a person', 'Available mornings');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1110, 0, 4435, 1, 'en', 'Notes', 'Further details on the unit and/or department. Here, additional information relevant for data retrieval can be entered. This can, for example, be opening hours or descriptions of how to get there.', 'Visitors: MON-FRI 9-12 hrs; THU 14-19 hrs');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1111, 0, 4440, 0, 'en', 'Tasks', 'Details on the responsibilities and tasking of an institution. The tasks and responsibilities of the institution entered should be represented in succinct, meaningful form. ', 'The formulation of the technical bases for the decisions of the regional governments in the area of nature conservation as well as the formulation of expert reports in particular cases as per Lower Saxony');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1112, 0, 4440, 2, 'en', 'Tasks', 'Details of the responsibilities and tasking of a person. The tasking and responsibilities of the person entered should be represented in succinct, meaningful form. ', 'Preparation of evictions from nature reserves; formulation of the boundaries of the areas; drafting of regulations');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1113, 0, 4440, 3, 'en', 'Tasks', 'Details of the responsibilities and tasking of a person. The tasking and responsibilities of the person entered should be represented in succinct, meaningful form. ', 'Preparation of evictions from nature reserves; formulation of the boundaries of the areas; drafting of regulations');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1114, 0, 4440, 1, 'en', 'Tasks', 'Details of the responsibilities and tasking of a unit. The tasking and responsibilities of the unit and/or department entered should be represented in succinct, meaningful form. ', 'Formulation of the technical bases for eviction from nature reserves as well as the formulation of expert reports as per Lower Saxony');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1115, 0, 4500, 0, 'en', 'Add Free Optional Topics', 'Input of keywords by means of which an institution can be found as quickly as possible in a keyword search and which are not available in the thesaurus. Here, concise terms and concepts, which are closely connected with the address and which do not already exist in the thesaurus, should be entered. These can be specialist areas, responsibilities or similar. The free search terms are to be given to enhance the thesaurus search terms. If you enter a thesaurus term it will be automatic identified and marked as a thesaurus term.', 'Nature protection, species protection, data collection');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1116, 0, 4500, 2, 'en', 'Add Free Optional Topics', 'Input of keywords by means of which a person can be found as quickly as possible in a keyword search and which are not available in the thesaurus. Here, concise terms and concepts, which are closely connected with the address and which do not already exist in the thesaurus, should be entered. These can be specialist areas, responsibilities or similar. The free search terms are to be given to enhance the thesaurus search terms. If you enter a thesaurus term it will be automatic identified and marked as a thesaurus term.', 'Moth mapping');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES
(1117, 0, 4500, 3, 'en', 'Add Free Optional Topics', 'Input of keywords by means of which a person can be found as quickly as possible in a keyword search and which are not available in the thesaurus. Here, concise terms and concepts, which are closely connected with the address and which do not already exist in the thesaurus, should be entered. These can be specialist areas, responsibilities or similar. The free search terms are to be given to enhance the thesaurus search terms. If you enter a thesaurus term it will be automatic identified and marked as a thesaurus term.', 'Moth mapping');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1118, 0, 4500, 1, 'en', 'Add Free Optional Topics', 'Input of keywords by means of which a unit can be found as quickly as possible in a keyword search and which are not available in the thesaurus. Here, concise terms and concepts, which are closely connected with the address and which do not already exist in the thesaurus, should be entered. These can be specialist areas, responsibilities or similar. The free search terms are to be given to enhance the thesaurus search terms. If you enter a thesaurus term it will be automatic identified and marked as a thesaurus term.', 'Species conservation mapping');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1119, 0, 4510, 0, 'en', 'Optional Topics', 'Input of at least three keywords if possible, which are listed in the thesaurus. The giving of keywords serves the themed subject retrieval of the address. For this keywords must be selected from the thesaurus which describe the address as precisely as possible but also as general as necessary. Thus a keyword in the thesaurus hierarchy should describe a relatively general aspect of the address and at least one keyword should describe the address as specifically as possible. The keywords can be selected with the assistance of the keyword assistant (keywords are suggested) or the thesaurus navigator. ', 'Nature protection; Butterfly; Mapping; Conservation of species');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1120, 0, 4510, 2, 'en', 'Optional Topics', 'Input of at least three keywords if possible, which are listed in the thesaurus. The giving of keywords serves the themed subject retrieval of the address. For this keywords must be selected from the thesaurus which describe the address as precisely as possible but also as general as necessary. Thus a keyword in the thesaurus hierarchy should describe a relatively general aspect of the address and at least one keyword should describe the address as specifically as possible. The keywords can be selected with the assistance of the keyword assistant (keywords are suggested) or the thesaurus navigator. ', 'Nature protection; Butterfly; Mapping; Conservation of species');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1121, 0, 4510, 3, 'en', 'Optional Topics', 'Input of at least three keywords if possible, which are listed in the thesaurus. The giving of keywords serves the themed subject retrieval of the address. For this keywords must be selected from the thesaurus which describe the address as precisely as possible but also as general as necessary. Thus a keyword in the thesaurus hierarchy should describe a relatively general aspect of the address and at least one keyword should describe the address as specifically as possible. The keywords can be selected with the assistance of the keyword assistant (keywords are suggested) or the thesaurus navigator. ', 'Nature protection; Butterfly; Mapping; Conservation of species');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1122, 0, 4510, -1, 'en', 'Optional Topics', 'Input of at least three keywords if possible, which are listed in the thesaurus. The giving of keywords serves the themed subject retrieval of the address. For this keywords must be selected from the thesaurus which describe the address as precisely as possible but also as general as necessary. Thus a keyword in the thesaurus hierarchy should describe a relatively general aspect of the address and at least one keyword should describe the address as specifically as possible. The keywords can be selected with the assistance of the keyword assistant (keywords are suggested) or the thesaurus navigator. ', 'Nature protection; Butterfly; Mapping; Conservation of species');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1123, 0, 4520, -1, 'en', 'Height', 'Entry of the values for the height in the given geodetic system. If there is a vertical extension then a larger value can be entered for the maximum. Should this not be the case then the input of a minimum is sufficient, this value will then also be taken for the maximum as well. ', '100 m');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1124, 0, 5000, 0, 'en', 'Short Description', 'Entry of a short description for an object. (Is supported in particular by GeoMIS.Bund)', 'DTK25 digital topographic map GK25 ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1125, 0, 5020, -1, 'en', 'Maximum', 'Entry of the values for the height in the given geodetic system. If there is a vertical extension then a larger value can be entered for the maximum. Should this not be the case then the input of a minimum is sufficient, this value will then also be taken for the maximum as well. ', 'Minimum 100, Maximum 110');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1126, 0, 5021, -1, 'en', 'Unit ', 'Stating the unit of measurement in which the height is measured.', 'Metres');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1127, 0, 5022, -1, 'en', 'Geodetic System', 'Entry of the reference level from which the height is measured relatively. In Germany this is generally the Amsterdam Level.', 'Amsterdam Level');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1128, 0, 5030, -1, 'en', 'Dataset Time', 'Statement as to when the data set was produced, revised and/or published.', 'Date: 11.11.2003, Type: Created');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1129, 0, 5040, -1, 'en', 'Suitability', 'Details about the possible use of this data in combination with further information.', 'Presentation of the regional planning programme on the basis of the topographic map books ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1130, 0, 5041, -1, 'en', 'Metadata Language ', 'Specification of the language of the metadata set.', 'German');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1131, 0, 5042, -1, 'en', 'Dataset Language ', 'Specification of the language of the data set.', 'German');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1132, 0, 5052, -1, 'en', 'Order Info', 'Description of terms and conditions of ordering the data.', 'Delivery time is 3 weeks');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1133, 0, 5060, 1, 'en', 'Categories', 'Entry of the main subjects which the metadata describe. Selection is done via the drop down list.', 'Environment');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1134, 0, 5061, 1, 'en', 'Dataset/Dataseries', 'The data described in the class Geo-information/map are stored in a single data set with a certain spatial reference or they are stored in a series of data sets with common thematic reference but different spatial references (e.g. data series: DTK25) ', 'Dataset');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1135, 0, 5062, 1, 'en', 'Digital Representation', 'Entry of the method of presenting spatial data. The selection takes place via a preset list.', 'Vector');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1136, 0, 5063, 1, 'en', 'Topology', 'Please note: only active after selecting "Vector" under "Digital Representation". There then appears a drop down list from which one term can be selected."', 'Geometric');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1137, 0, 5064, 1, 'en', 'INSPIRE-Topics', 'Selection of an INSPIRE subject area for providing keywords from the data set (INSPIRE-obligatory field)', 'Soil');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1138, 0, 5066, 1, 'en', 'Service Link', 'Geo-referenced data can get a link to an OGC web service which was described in the class Geo-service, if they are base data to the web service. These geo data are, as a rule, closely coupled to the service and directly reachable via the linked OGC web service.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1139, 0, 5069, 1, 'en', 'Height Accuracy', 'Statement as to the accuracy of the height, for example, in a terrain model.', '2');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1140, 0, 5070, 1, 'en', 'Attributes', 'Details of the factual data connected with the geo-information/map. If needed, a listing of the attributes of the data inventory can be done here. The main use of this field is envisaged for digital geo-information.', 'Tree index');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1141, 0, 5201, 3, 'en', 'Name of the Operation', 'Name of the function/operation provided by a service. Here a distinct designator has to be entered for the operation described.', 'getMap getCapabilities getFeatureInfo');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1142, 0, 5202, 3, 'en', 'Description ', 'Textual description of the functionality of the operation.', 'The getMap operation of the WMS provides a raster representation of the digital map.');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1143, 0, 5203, 3, 'en', 'Supported Platforms ', 'Listing of the type of the platform and/or interface by means of which the service can be accessed.', 'Java; SQL; HTTPGet; HTTPSoap');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1144, 0, 5204, 3, 'en', 'Call', 'Distinct function name by means of which the operation can be requested. With OGC web services the respective specific REQUEST-calls are to be used.', 'getMap; getCapabilities; getFeatureInfo');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1145, 0, 5205, 3, 'en', 'Parameters', 'Possible parameters which can be passed when the operation is called up. ', 'Name: WIDTH, Direction: Input, Description: "The parameter WIDTH defines the width of the map picture produced by the WMS", Is optional: yes, multiple input: no');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1146, 0, 5206, 3, 'en', 'URL', 'Distinct URL by means of which the operation can be called up.', 'http://my.host.com/cgi-bin/mapserv?map=mywms.map&');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1147, 0, 5207, 3, 'en', 'Dependencies', 'The names of the operations which have to be carried out before the current operation, if the operation is to be used as part of a service chain.', 'For the "getMap" operation: "getCapabilities"');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1148, 0, 7000, -1, 'en', 'Relevance', 'The object classes are differentiated by different description fields in the relevance register card.n- Organisational Unit / Task: Responsibilities of Institutions or organisational units, specialist area or task;n- Geoinformation / Map: GIS data, analogue maps or map books;n- Document / Report / Literature: Brochures, books, essays, reports, etc. Of interest in particular are documents which are not obtainable via bookshops or via libraries (''grey literature'');n- Geo-Service: Services which provide spatial data, in particular INSPIRE-services and service in the context of national geo data infrastructures;n- Enterprise / Project / Program: Research and development plans, projects with the participation of other institutions or private companies, conservation programmes. Of particular interest are schemes/projects/programmes in which relevant data bases arise;n- Data Pooling / Data Base: Analog or digital collection of data. Examples: measurement data, statistical surveys, model data, data on installation(s);n- Service / Application / Informationsystem: Central information systems, which as a rule access one or multiple databanks and make these accessible.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1149, 0, 7001, -1, 'en', 'Spatial Reference', 'Details of the reference systems (position, height, gravity), which were laid down as the basis for the production of the data base to be described or of the commercial map. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1150, 0, 7002, -1, 'en', 'Temporal Reference', 'Details of the temporal reference of the data set and the data contents', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1151, 0, 7003, -1, 'en', 'Additional Information', 'General details on the data such as language and place of publication of the data set ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1152, 0, 7004, -1, 'en', 'Availability', 'Information what kind of access or use restrictions are placed on the data', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1153, 0, 7005, -1, 'en', 'Keywords', 'Details of keywords to improve the search for data', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1154, 0, 7006, -1, 'en', 'Display as Catalogue Page', 'Select whether data object is to be displayed as a catalogue page in the Portal', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1155, 0, 7007, -1, 'en', 'Links', 'Display of links to other objects/URLs and possibility of new input and/or processing of references.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1156, 0, 7008, -1, 'en', 'Address and Tasks ', 'Details of address data for communication with relevant contact point as well as additional information (notices and tasks) on this', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1157, 0, 7009, -1, 'en', 'Keywords - Section Header', 'Giving keywords to simplify the search for the address data', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1158, 0, 7010, -1, 'en', 'Assigned Objects', 'In this table all references from those objects which refer to the current address are entered. Editing or adding is not possible. Should the references be altered or added, then you have to switch to the object concerned.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1159, 0, 7011, -1, 'en', 'General', 'Input of general information on the object (description, contact information)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1160, 0, 7012, -1, 'en', 'i-Info Transformed Coordinates', 'Transformation of the data selected under Geothesaurus-Reference to the coordinate systems available in the drop down box', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1161, 0, 7013, -1, 'en', 'i-Info Transformed Coordinates ', 'Transformation of the data selected under Custom Location into the coordinates systems available in the drop down box', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1162, 0, 7014, -1, 'en', 'Vector Format', 'Attention: only active after selecting "Vector" under "Digital Representation". Here topological information, Geometry Type (detail of the geometric objects, to describe the geometric position) and Element Count (details of the number of the point or vector type elements) can be given.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1163, 0, 7015, -1, 'en', 'Operations', 'Information on operations with regard to web services such as getMap, getCapabilities and getFeatureInfo', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1164, 0, 7016, -1, 'en', 'Add/Edit Objects', 'Form to add and edit on meta data objects of the 7 different object classes', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1165, 0, 7017, -1, 'en', 'Unit/Institution', 'Input of the name of the unit and/or institution which is to be searched for.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1166, 0, 7018, -1, 'en', 'Surname', 'Giving the name of the person being searched for', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1167, 0, 7019, -1, 'en', 'Forename', 'Giving the first name of the person to be searched for', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1168, 0, 7020, -1, 'en', 'Geothesaurus-Navigator ', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1169, 0, 7021, -1, 'en', 'Geothesaurus-Navigator ', 'Entering the spatial unit whose coordinates are to be searched for e.g. Berlin', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1170, 0, 7022, -1, 'en', 'Add Custom Location', 'Here the coordinates of a bounding box, which encloses the object, can be given. In point-shaped locations the same coordinate is given twice: Longitude1=Longitude 2 and Latitude1=Latitude 2', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1171, 0, 7023, -1, 'en', 'Custom Location (input field)', 'input of a freely selectable name for the new spatial relationship.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1172, 0, 7024, -1, 'en', 'Lower Left - Longitude 1', 'Input of the x-value for the bottom left coordinate of the Bounding Box', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1173, 0, 7025, -1, 'en', 'Lower Left - Latitude 1', 'Input of the y-value for the bottom left coordinate of the Bounding Box', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1174, 0, 7026, -1, 'en', 'Upper Right - Longitude 2', 'Input of the x-value of the upper right coordinate of the Bounding Box', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1175, 0, 7027, -1, 'en', 'Upper Right - Latitude 2', 'Input of the y-value of the upper right coordinate of the Bounding Box', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1176, 0, 7028, -1, 'en', 'Coordinates System', 'Selection of the coordinates system used for the giving coordinates from a list.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1177, 0, 7029, -1, 'en', 'Thesaurus-Assistant', 'Here keywords are automatically generated on the basis of the text fields already filled in. They have to be accepted by the user.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1178, 0, 7030, -1, 'en', 'Thesaurus-Navigator', 'It can be searched for descriptors or defining concepts in the thesaurus or keywords can be selected directly in the hierarchy tree. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1179, 0, 7031, -1, 'en', 'Search for Descriptors', 'Search for descriptors or defining concepts in the thesaurus. The results of the search are displayed on the "results list" card of the index and can be accepted from there.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1180, 0, 7032, -1, 'en', 'Descriptor List', 'Display of the descriptors added from the hierarchy tree or the search result list. These are supplemented via the ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1181, 0, 7033, -1, 'en', 'Add/Edit Links', '[?]', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1182, 0, 7034, -1, 'en', 'Link From', 'On the right side under the ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1183, 0, 7035, -1, 'en', 'Object Name', 'Display of the name of the object currently being edited.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1184, 0, 7037, -1, 'en', 'Link Type', 'Selection whether the reference should be made to an object in the catalogue or to a website (URL).', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1185, 0, 7038, -1, 'en', 'Link To', 'Display of the object or the URL indicated by the reference. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1186, 0, 7040, -1, 'en', 'Object Class', 'The class of the object indicated by the link is displayed.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1187, 0, 7041, -1, 'en', 'Add/Edit Operations', 'Information on operations with regard to web services such as getMap, getCapabilities and getFeatureInfo', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1188, 0, 7042, -1, 'en', 'Show/Edit Comments', 'View and make comments to the object.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1189, 0, 7043, -1, 'en', 'Edit Comment Content', 'Write a new comment to the object', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1190, 0, 7044, -1, 'en', 'Address Title', 'Gives a arbitrary name for the address object', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1191, 0, 7045, -1, 'en', 'Address Type', 'Giving the type of the address object - institution, unit or person', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1192, 0, 7046, -1, 'en', 'Search Mode', 'Decision whether search should be run with entire search words or substrings', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1193, 0, 7047, -1, 'en', 'Search Terms for Thesaurus', 'Input of a (thesaurus-) term for which similar terms are to be searched.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1194, 0, 7048, -1, 'en', 'Search Terms', 'Search terms accepted from thesaurus-search, with which a data object shall to be found', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1195, 0, 7049, -1, 'en', 'Search Terms for Geo-Thesaurus', 'Input of spatial terms to be used in searching in the geo-thesaurus e.g. Berlin', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1196, 0, 7050, -1, 'en', 'Geo-Thesaurus Search Terms', 'Terms accepted from geo-thesaurus-search, which describe the spatial reference of the object.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1197, 0, 7051, -1, 'en', 'Custom Location', 'Input of a free spatial reference used in the catalogue to search for data objects', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1198, 0, 7052, -1, 'en', 'Temporal Reference', 'Input of a time point or time zone to localise an object (search for "time reference of the data contents")', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1199, 0, 7053, -1, 'en', 'Additional Parameters', 'Selection if the time point or the time zone of the object searched lies within or outside the time reference given above', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1200, 0, 7054, -1, 'en', 'Search Mode', 'Decision whether search should be run with entire search words or substrings', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1201, 0, 7055, -1, 'en', 'Search in the Following Fields', 'Decision if the search should be run in all text fields of a data object or only in certain ones. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1202, 0, 7056, -1, 'en', 'Addresses -  Additional Parameters', 'Search for address information such as street, place or post code in address objects', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1203, 0, 7057, -1, 'en', 'Street', 'Search for street names in an address object', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1204, 0, 7058, -1, 'en', 'Post Code', 'Search for post codes in an address object', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1205, 0, 7059, -1, 'en', 'City', 'Search for city names in an address object', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1206, 0, 7060, -1, 'en', 'Search - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1207, 0, 7061, -1, 'en', 'Thesaurus Navigator - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1208, 0, 7062, -1, 'en', 'Thesaurus Navigator - access to the thesaurus hierarchy', 'Search for thesaurus terms and their position in the thesaurus hierarchy tree', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1209, 0, 7063, -1, 'en', 'Database Search - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1210, 0, 7064, -1, 'en', 'Database Search - database search', 'Search for objects with help of the Hibernate Query Language-syntax (HQL)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1211, 0, 7065, -1, 'en', 'Quality Assurance - Editor/Responsible User - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1212, 0, 7066, -1, 'en', 'Quality Assurance - Editor/Responsible User - Expired Objects / Addresses ', 'Display of objects and addresses that have to be checked as the expiry period has run out. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1213, 0, 7067, -1, 'en', 'Quality Assurance - Editor/Responsible User - Objects / Addresses which have been modified', 'Display of objects and addresses that are currently being worked on, i.e. have not yet been published. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1214, 0, 7068, -1, 'en', 'Quality Assurance - Editor/Responsible User - Objects / Addresses assigned to QA or reassigned by the QA ', 'Display of objects that are in the quality assurance cycle, that is, have not been published', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1215, 0, 7069, -1, 'en', 'Quality Assurance - Quality Assurance - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1216, 0, 7070, -1, 'en', 'Quality Assurance - Quality Assurance - Objects / Addresses assigned to you for qa', 'Display of objects/addresses, which has to be checked by quality assurance ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1217, 0, 7071, -1, 'en', 'Quality Assurance - Quality Assurance - Objects / Addresses which have been modified and for which you are responsible for qa', 'Display of objects/addresses, which has to be checked by quality assurance ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1218, 0, 7072, -1, 'en', 'Quality Assurance - Quality Assurance - Objects / Addresses which have expired and for which you are responsible for qa', 'Display of objects/addresses, for which you are responsible for quality assurance and which have to be reviewed', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1219, 0, 7073, -1, 'en', 'Quality Assurance - Quality Assurance - Objects with expired Spatial References and for which you are responsible for qa', 'Display of objects/addresses, whose spatial relationship has expired and for the quality assurance of which you are responsible ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1220, 0, 7074, -1, 'en', 'Select Object', 'With the help of the structure tree an object can be selected which is to be referenced. After the selection has been made, activate the "reference" button.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1221, 0, 8000, -1, 'en', 'Catalogue Settings', 'Information on the catalogue such as, for example the name of the catalogue, provider or language of the catalogue', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1222, 0, 8001, -1, 'en', 'Catalogue Name', 'The name of the catalogue should reflect the contents of the catalogue.', 'Environmental Catalogue Lower Saxony');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1223, 0, 8002, -1, 'en', 'Partner Name', 'Specification of the name of the partner', 'Germany');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1224, 0, 8003, -1, 'en', 'Provider Name', 'Specification of the name of the provider', 'Saxon State Ministry for the Environment and Agriculture');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1225, 0, 8004, -1, 'en', 'State', 'Name of the state in which the catalogue is based', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1226, 0, 8005, -1, 'en', 'Catalogue Language', 'Specification of the language of the catalogue', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1227, 0, 8006, -1, 'en', 'Location', 'Here the spatial entity can be selected by means of the ', 'Berlin');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1228, 0, 8007, -1, 'en', 'Select Location ', 'Here a spatial entity can be selected for the catalogue.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1229, 0, 8008, -1, 'en', 'Select Spatial Reference', 'A location can be entered for which will be searched within the gazetteer', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1230, 0, 8009, -1, 'en', 'Field Settings', 'Here a selection can be made as to whether a field is visible when an object is first opened or whether it should first be expanded.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1231, 0, 8010, -1, 'en', 'Display following fields also in standard view', 'Here a selection can be made as to whether a field is visible when an object is first opened or whether it should first be expanded.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1232, 0, 8011, -1, 'en', 'User Management', 'Here users, who may work with the metadata editor, can be administered. The user receives the relevant rights to work with the catalogue by the addition of a group. Only new users can be added who have already been set up in the Portal and so far still have no editor rights. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1233, 0, 8012, -1, 'en', 'User Data', 'Here details on the relevant user can be altered or tested.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1234, 0, 8013, -1, 'en', 'Login', 'Login-Name of the corresponding user. Equates to the name which was given in the Portal.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1235, 0, 8014, -1, 'en', 'Role', 'The role of the user is allocated via the Portal administration and can not be changed here. The possible ones are catalogue administrator, Metadata-Administrator (with QA rights) and Metadata-Author', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1236, 0, 8015, -1, 'en', 'Address', 'Allocation of an address from the catalogue - via the ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1237, 0, 8016, -1, 'en', 'Groups', 'Through the group, rights for the processing of objects or addresses in certain sub trees of the catalogue are assigned.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1238, 0, 8017, -1, 'en', 'Group Administration', 'Through the group, rights for the processing of objects or addresses in certain sub trees of the catalogue are awarded. Furthermore, a selection can be made as to whether the user may release objects and addresses (person responsible for quality assurance).', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1239, 0, 8018, -1, 'en', 'Group Data', 'Input of a name for a new group ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1240, 0, 8019, -1, 'en', 'Group Name', 'Name of the group ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1241, 0, 8020, -1, 'en', 'Create Root objects and addresses', 'This function allows the creation of new sub trees at the same level as the released object or object tree ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1242, 0, 8021, -1, 'en', 'Quality Assurance', 'A person responsible for quality assurance has the right to release altered objects so that they can then be found via the portal search. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1243, 0, 8022, -1, 'en', 'Object Permissions', 'Here objects can be selected that can be processed by the group. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1244, 0, 8023, -1, 'en', 'Address Permissions', 'Here addresses can be selected that can be processed by the group. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1245, 0, 8024, -1, 'en', 'Permission Overview', 'Here is displayed which user may work on an object selected, which role he possesses and whether he may work on the sub tree under it and whether he has QA rights', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1246, 0, 8025, -1, 'en', 'Object Permissions', 'Selection of an object for which all users are displayed who are allowed to make changes.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1247, 0, 8026, -1, 'en', 'Address Permissions', 'Selection of an address for which all users are displayed who are allowed to make changes.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1248, 0, 8028, -1, 'en', 'Analysis ', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1249, 0, 8029, -1, 'en', 'Duplicates ', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1250, 0, 8030, -1, 'en', 'Object Name', 'Display of the name of the object selected in the left column', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1251, 0, 8031, -1, 'en', 'Type', 'Display of the object class of the objects selected in the left column', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1252, 0, 8032, -1, 'en', 'Description', 'Display of the object description of the objects selected in the left column', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1253, 0, 8033, -1, 'en', 'URL-Validation - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1254, 0, 8034, -1, 'en', 'Replace selected URLs with', 'Input of a new URL that shall replace the marked URLs in the table', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1255, 0, 8035, -1, 'en', 'Code lists - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1256, 0, 8036, -1, 'en', 'Code list', 'Selection of an ISO- or other code list which entries shall be checked', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1257, 0, 8037, -1, 'en', 'Set Default', 'Selection whether and which entry in the list is to be displayed by default, that is the first visible in the drop down box', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1258, 0, 8038, -1, 'en', 'List: Legal Basis', 'Editing of the drop down list "legal basis"', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1259, 0, 8039, -1, 'en', 'Additional Fields ', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1260, 0, 8040, -1, 'en', 'Additional Fields ', 'Input of a name for a new, additional field', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1261, 0, 8041, -1, 'en', 'Additional fields - length', 'Input of the length of a text field ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1262, 0, 8042, -1, 'en', 'Additional fields - type', 'Selection of the type of a new additional field ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1263, 0, 8043, -1, 'en', 'Replace address ', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1264, 0, 8044, -1, 'en', 'Title', 'Display of the name of the address object selected in the hierarchy tree', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1265, 0, 8045, -1, 'en', 'Creation Date', 'Display of the date of creation of the address object selected in the hierarchy tree', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1266, 0, 8046, -1, 'en', 'Responsible User', 'Display of the person responsible of the address object selected in the hierarchy tree', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1267, 0, 8047, -1, 'en', 'ID', 'Display of the objekt ID of the address object selected in the hierarchy tree', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1268, 0, 8048, -1, 'en', 'Quality Assurance', 'Display of the QA-representative for the address object selected', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1269, 0, 8049, -1, 'en', 'Title', 'Display of the name of the address object selected in the hierarchy tree', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1270, 0, 8050, -1, 'en', 'Creation Date', 'Display of the date of creation of the address object selected in the hierarchy tree', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1271, 0, 8051, -1, 'en', 'Responsible User', 'Display of the person responsible of the address object selected in the hierarchy tree', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1272, 0, 8052, -1, 'en', 'ID', 'Display of the objekt ID of the address object selected in the hierarchy tree', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1273, 0, 8053, -1, 'en', 'Quality Assurance', 'Display of the QA-representative for the address object selected', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1274, 0, 8054, -1, 'en', 'Search terms - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1275, 0, 8055, -1, 'en', 'Select the update dataset', 'Selection of a local file with updated thesaurus data', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1276, 0, 8056, -1, 'en', 'Location search terms - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1277, 0, 8057, -1, 'en', 'Select the update dataset ', 'Selection of a local file with updated spatial reference data', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1278, 0, 8058, -1, 'en', 'General settings ', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1279, 0, 8059, -1, 'en', 'General settings', 'Set properties for automatic saving and for automatic session-renewal ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1280, 0, 8060, -1, 'en', 'Select Import File', 'Select the local XML-import file (import of all code lists)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1281, 0, 8061, -1, 'en', 'Capabilities URL', 'Enter the getCapability-URL of the corresponding service', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1282, 0, 8063, -1, 'en', 'URL of the page to analyze', 'Input of the URL of the internet page to be analysed', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1283, 0, 8064, -1, 'en', 'Number of words to be analysed', 'Specification of the maximum number of words to be analysed - changes the duration of the analysis', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1284, 0, 8065, -1, 'en', 'Show the description of the page', 'Optional analysis of the meta-tag ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1285, 0, 8066, -1, 'en', 'Add title', 'Selection whether the title should be adopted for the new data object (meta-tag "title")', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1286, 0, 8067, -1, 'en', 'Add description', 'Selection whether the description should be adopted for the new data object (meta-tag ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1287, 0, 8068, -1, 'en', 'Add content', 'Selection whether the first rows of the specified web page should be adopted as description of the object.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1288, 0, 8069, -1, 'en', 'Descriptors', 'Selection, which descriptor shall be used for the object. By double clicking in the first column of the table you can activate a checkbox for selection of the chosen descriptor.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1289, 0, 8070, -1, 'en', 'Select all Descriptors', 'Select whether all descriptors shown should be adopted to the object', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1290, 0, 8071, -1, 'en', 'Spatial reference', 'Selection, which spatial term shall be used as spatial reference within the object. By double clicking in the first column of the table you can activate a checkbox for selection of the chosen term.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1291, 0, 8072, -1, 'en', 'Select all Spatial references', 'Select whether all proposed spatial references should be adopted to the object', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1292, 0, 8073, -1, 'en', 'Time', 'Selection, which time-reference shall be used within the object. By double clicking in the first column of the table you can activate a checkbox for selection of the chosen time-reference.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1293, 0, 8074, -1, 'en', 'Import-file', 'Select a local file with the data sets to be imported', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1294, 0, 8075, -1, 'en', 'Publish imported datasets', 'Select whether new data sets are to be published directly', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1295, 0, 8076, -1, 'en', 'Create datasets solely under the import nodes', 'Select whether imported data sets should not be inserted to possible available former position', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1296, 0, 8077, -1, 'en', 'Parent object', 'Selection of a parent object under which the imported objects are to be placed.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1297, 0, 8078, -1, 'en', 'Parent address', 'Selection of a parent address under which the imported adresses are to be placed.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1298, 0, 8079, -1, 'en', 'Import ', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1299, 0, 8080, -1, 'en', 'Export ', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1300, 0, 8081, -1, 'en', 'Criteria Export', 'Export of objects in which the selected term was entered in the field "xml-export-criteron"', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1301, 0, 8082, -1, 'en', 'Tree Export', 'Export of all data sets of the sub tree selected. Please enter the node from which you like to export all sub objects.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1302, 0, 8083, -1, 'en', 'Export the selected node only', 'Export only the object that you have selected as node.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1303, 0, 8084, -1, 'en', 'Additional fields ', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1304, 0, 8085, -1, 'en', 'Subtree import', 'To carry out a subtree import, the giving of a Parent Object and a Parent Address is always necessary. All objects and addresses that do not yet exist are filed underneath these import nodes. In so doing a structure of the objects or addresses supplied in the import file is kept if necessary.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1305, 0, 8086, -1, 'en', 'Compare view addresses - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1306, 0, 8087, -1, 'en', 'Compare view objects - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1307, 0, 8088, -1, 'en', 'Common create object wizard - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1308, 0, 8089, -1, 'en', 'getCapabilities Wizard - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1309, 0, 8090, -1, 'en', 'File Dialogue - general help', '', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1310, 0, 10006, -1, 'en', 'Gazetteer-reference', 'Information about the spatial allocation of the data inventory described in the object. The coordinates of the spatial entity can be searched for via the Gazetteer-Navigator.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1311, 0, 10008, -1, 'en', 'Custom Location', 'Information on the spatial allocation of the data base described in the object. Freely selectable spatial coordinates can be added.nThe range of values is defined in WGS as follows:n-  Latitude: -90 bis 90n-  Longitude: -180 bis 180', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1312, 0, 10011, -1, 'en', 'Content Time', 'Here the date of original data (e.g. monitoring data) shall be entered ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1313, 0, 10013, -1, 'en', 'Purpose', 'Reason for data acquisition', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1314, 0, 10014, -1, 'en', 'Environmental', 'The use of environmental keywords is to generate an allocation of the objects to roughly allocated topics and categories. These topics and categories are contained in the drop down lists. Multiple entries can be made. Via the ''show as catalogue page'' it can be decided whether the object is to be used as a catalogue page in the portal. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1315, 0, 10015, -1, 'en', 'Topics', 'Here suitable topics for the object are selected from a list. At least one subject area is to be selected.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1316, 0, 10016, -1, 'en', 'Categories', 'Here suitable categories for the object are selected from a list. At least one category is to be selected.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1317, 0, 10021, -1, 'en', 'Identification', 'Here a unique identification has to be given for every data source described in the data object (e.g. a map). (INSPIRE-obligatory field)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1318, 0, 10022, 3, 'en', 'Classification of Service', 'Selection of the description of the service. This field primarily used for search by a user.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1319, 0, 10024, -1, 'en', 'Conformity', 'Here must be stated with which execution condition of the INSPIRE-guideline and/or to which external specification the data described are conform. (INSPIRE-obligatory field)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1320, 0, 10025, -1, 'en', 'Access Constraints', 'The field describes the kind of access constraints. For free usable data or services ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1321, 0, 7075, -1, 'en', 'Additional Fields', 'Additional fields are only defined for the actual catalogue and are additional to the standard fields of the InGrid-Catalogue.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1322, 0, 10026, -1, 'en', 'Usage Limitations', 'In the field ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1323, 0, 3260, 3, 'en', 'Access restricted', 'The checkbox ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1324, 0, 1010, 6, 'en', 'Description', 'Technical contents of the Service, Application or Information System. Here the type of the Service, Application or Information System as well as the technical information contents is to be described. Care should be taken over comprehensibility for none specialists. Technical IT details should be limited to central, characteristic aspects. The descriptions field must be filled in so that the object can be saved.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1325, 0, 3620, 6, 'en', 'Type of Service', 'Within this mandatory field you can choose the type of the service. You can choose one of the following entries: "Information System", "non geographical Service" and "Application". If your service is a geographical service, please choose the object class "Geo-Service".', '"Informationsystem"; "non geographical Service"; "Application"');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1326, 0, 3630, 6, 'en', 'Service Version', 'Details on the version of the underlying base specification of the service (Please enter all versions supported by the service).', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1327, 0, 3600, 6, 'en', 'Environment', 'Details on the operating system, the software and, where applicable, hardware used to carry out the service.', 'UMN Mapserver 4.0.2 on Linux 2.6.0 for real-time and near-online GPS-applications: Correction data receiver for post processing applications: GPS-evaluation software');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1328, 0, 3640, 6, 'en', 'History', 'Details on the development history. Here precursors and follow-up services and/or applications or systems can be named. Likewise, details on related research projects or programmes are of interest. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1329, 0, 3645, 6, 'en', 'General', 'Origin and type of the underlying data. In general, these are the data sets on which the service is based. In general, the origin or the start data of the data are described, which are used in the service, application or information system, stored, displayed or processed further. In addition, the type of the data (e.g. digital, automatically produced or taken from survey results, primary data, error-adjusted data). The entry here can take place directly via the selection of the ''text'' register card or references can be entered by selecting the link "insert/edit reference".', 'Readings for emissions in certain firms ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1330, 0, 3650, 6, 'en', 'Description', 'Additional explanatory notes on the service, application or information system described. Here it is possible to give further information, e.g. of technical nature, necessary for the understanding of the service, the application and the information system. ', 'The data set is a shape file which contains all ground water measuring locations in Hessen with position and designator. ');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1331, 0, 3670, 6, 'en', 'Service-Urls', 'Input of the URL of the information system, service or application. The name, URL and a short description of the reference have to be given.', 'Name: PortalU; URL: http://www.portalu.de; Description: Umweltportal Deutschland');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1332, 0, 5043, -1, 'en', 'Dataset Character Set ', 'Specification of the character set used in the data set described, e.g. UTF-8', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1333, 0, 7500, -1, 'en', 'Data Quality', 'Description of the data quality of the specified data set', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1334, 0, 7509, -1, 'en', 'Completeness Commission', 'Number of excess items in the dataset in relation to the number of items that should have been present; e.g. number of excess items: 11,2% (NOTE: Enter only the number; NO %-character)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1335, 0, 7510, -1, 'en', 'Completeness Omission', 'Number of missing items in the dataset in relation to the number of items that should have been present; e.g. number of excess items: 5,3% (NOTE: Enter only the number; NO %-character)', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1336, 0, 7512, -1, 'en', 'Conceptual Consistency', 'Specification of errors regarding the violation of rules of the conceptual schema; Example: number of invalid overlaps of surfaces within the dataset: 23', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1337, 0, 7513, -1, 'en', 'Domain Consistency', 'Domain consistency should be documented using the value domain conformance rate. Enter the number of items in the dataset that are in conformance with their value domain in relation to the total number of items in the dataset.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1338, 0, 7514, -1, 'en', 'Format Consistency', 'Enter the percentage of items stored in conflict with the physical structure of the dataset.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1339, 0, 7515, -1, 'en', 'Topological Consistency', 'Description of topological errors that appear between different sub-elements of the dataset. Example: Number of missing connections due to undershoots / overshoots', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1340, 0, 7517, -1, 'en', 'Absolute External Positional Accuracy', 'Mean value of the positional uncertainties for a set of positions where the positional uncertainties are defined as the distance between a measured position and what is considered as the corresponding true position.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1341, 0, 7520, -1, 'en', 'Temporal Accuracy', 'Temporal consistency should be documented using percentage of items that are correctly ordered events in relation to all items.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1342, 0, 7525, -1, 'en', 'Thematic Classification Correctness', 'Average number of incorrectly classified features in relation to the number of features that are supposed to be within the dataset.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1343, 0, 7526, -1, 'en', 'Non Quantitative Attribute Accuracy', 'Total number of erroneous non-quantitative attribute values within the relevant part of the dataset.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1344, 0, 7527, -1, 'en', 'Quantitative Attribute Accuracy', 'Quantitative attribute correctness should be documented using the attribute value uncertainty at 95 % significance level. Enter the count of all attribute values where the value is incorrect.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1345, 0, 7527, -1, 'en', 'Quantitative Attribute Accuracy', 'Quantitative attribute correctness should be documented using the attribute value uncertainty at 95 % significance level. Enter the count of all attribute values where the value is incorrect.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1346, 0, 3000, 6, 'en', 'Object Name', 'Information in the form of a brief, succinct description of the Service, Application or Information System being described. The object name can, for example, be identical with the name of the Service as long as this is sufficiently brief and meaningful.  Where there is an abbreviation in common use then this abbreviation is to be given as well. Making an entry in this field is obligatory.', 'Remote Monitoring of Emissions RME');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1347, 0, 10101, -1, 'en', 'ID', 'The ID of a field has to be unique. Otherwise data can not be connected to a field in correct way. At the creation of a new field the uniqueness of an ID is checked and an error message is displayed where appropriate. The ID may consist of an arbitrary character string but should include a meaningful name. After the ID has defined once it can never be changed.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1348, 0, 10102, -1, 'en', 'Required Field', 'The filed will be treated as a mandatory field if this selection is activated. Then it is displayed in bold letters and labeld with a ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1349, 0, 10103, -1, 'en', 'Visibility ', 'There are different Options which influence the visibility of the field:noptionaln  Initial the field is not shown. It will only be visible if the corresponding category is expandednshown  The field is always shown even if the category isn', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1350, 0, 10104, -1, 'en', 'Label', 'Here the Label of the field is specified. It can be specified in different languages. An English label is mandatory. Is the editor displayed in a language for which no label was defined it is displayed in the default language English.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1351, 0, 10105, -1, 'en', 'Help text', 'In this area the help text to the new defined field is specified. In the editor he will be displayed by clicking on the label of the field. It can be specified in different languages. An English label is mandatory. Is the editor displayed in a language for which no label was defined it is displayed in the default language English.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1352, 0, 10106, -1, 'en', 'Scripts', 'It is possible to run additional java script code in this area. This can advance the functionality of the field e.g. to react on an event. Beneath the IDF-mapping the code in java script is deposited which is needed to map the field to the InGrid data format. ', '// allows only valid email addresses (with ID "userEmail") in a textbox ndijit.byId("userEmail").regExpGen = dojox.validate.regexp.emailAddress;nn// special validation of a textboxndijit.byId("doNotAllowNoInTextfield").validator = function(value) {if (value == "NO") return false; else return true;}nn// validation before a publicationndojo.subscribe("/onBeforeObjectPublish", function(/*Array*/notPublishableIDs) { if (dijit.byId("aField").get("value")) == "Kein" notPublishableIDs.push("aField");})');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1353, 0, 10107, -1, 'en', 'Entries', 'Here the entries for the selection lists are defined. The ID is created automatically. It is necessary to guarantee a correct link to the different language versions of a list entry. Furthermore it is possible to change the order of the entries by click into the first column of the table and pull the entry to the desired position.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1354, 0, 10108, -1, 'en', 'Unit', 'The unit which is displayed behind the number box. If this field is empty no unit will be displayed.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1355, 0, 10109, -1, 'en', 'Index name', 'Indicates by which name this field shall be referenced in the index. If the field is empty the field will not be stored in the index!', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1356, 0, 10110, -1, 'en', 'Width', 'Defines the width of a field in percentage. 100% means the entire possible width. 50% means the half of the possible width. If you define two consecutive fields with a width of 50 percent, the second one will be displayed right from the first. By choosing different width for consecutive fields different arrangements of fields can be achieved.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1357, 0, 10111, -1, 'en', 'Number of rows', 'If a text field is defined, there is the possibility to define the number of rows of the field.', '3');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1358, 0, 10111, -1, 'en', 'Number of rows', 'If a text field is defined, there is the possibility to define the number of rows of the field.', '3');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1359, 0, 10113, -1, 'en', 'Columns definition', 'Here it is possible to add or delete columns of the table. The different Types for columns are: text field, number field, date field and code list. By creation of a table at least one column has to be defined!', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1360, 0, 10114, -1, 'en', 'Allow Custom Entries', 'If this option is activated it is also possible to add a free entry to the code list. In the other case only an entry of the code list can be chosen. The entries can be done in different languages, so by changing the language in the InGrid-Editor the list entry is adapted.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1361, 0, 10150, -1, 'en', 'Type', 'The type of field of this column. It can be a text field, number field, date field and code list. ', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1362, 0, 10151, -1, 'en', 'ID', 'The ID of the column must be unique within the table.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1363, 0, 10152, -1, 'en', 'Label', 'Here the Label of the column is specified. It can be specified in different languages. An English label is mandatory. Is the editor displayed in a language for which no label was defined it is displayed in the default language English.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1364, 0, 10154, -1, 'en', 'Width', 'Defines the width in number of pixel.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1365, 0, 10154, -1, 'en', 'Width', 'Defines the width in number of pixel.', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1366, 0, 10155, -1, 'en', 'Index name', 'Indicates by which name this column shall be referenced in the index. If the field is empty the column will not be stored in the index!', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1368, 0, 3000, 6, 'en', 'Object Name', 'Information in the form of a brief, succinct description of the Service, Application or Information System being described. The object name can, for example, be identical with the name of the Service as long as this is sufficiently brief and meaningful.  Where there is an abbreviation in common use then this abbreviation is to be given as well. Making an entry in this field is obligatory.', 'Remote Monitoring of Emissions RME');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1370, 0, 8174, -1, 'en', 'Import-Typ', 'There are three different formats that can be imported:nnInGrid Catalog: the import takes place in the same format as the Export.nnCSW 2.0.2 AP ISO 1.0 (Single Metadata file): The import file must consist of a valid XML document in the OGC format of the Catalog Service Web (CSW) in the 2.0.2 version and be in accordance with the ISO 1.0 definition of the application profile. In so doing only one file can be imported that contains exactly one metadata set in this format.nnArcGIS ISO-Editor: Import of an XML file produced with the help of ArcGIS. The document must have been saved out of ArcGIS in the ISO format', '');
INSERT INTO help_messages (id, version, gui_id, entity_class, language, name, help_text, sample) VALUES 
(1371, 0, 7076, -1, 'en', 'Quality Assurance - Editor/Responsible User - Objects with expired Spatial References', 'Display of objects and addresses that spatial references have to be checked as invalid. ', '');
