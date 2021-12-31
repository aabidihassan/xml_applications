DROP TABLE IF EXISTS root;              
                CREATE TABLE root(root_id INT NOT NULL, idAdmin VARCHAR2 (*),idClient VARCHAR2 (*),idGestionnaire VARCHAR2 (*),referenceCmd VARCHAR2 (*),dateCmd DATE,referenceProd VARCHAR2 (*),referenceCat VARCHAR2 (*),nomCat VARCHAR2 (*),referenceProd VARCHAR2 (*),libelle VARCHAR2 (*),dateProduit DATE,
                PRIMARY KEY(root_id ) );
                
