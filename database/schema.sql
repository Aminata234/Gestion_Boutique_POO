CREATE TABLE produit (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prix_achat NUMERIC(12,2) NOT NULL CHECK (prix_achat >= 0),
    prix_vente NUMERIC(12,2) NOT NULL CHECK (prix_vente >= 0),
    quantite_stock INTEGER NOT NULL DEFAULT 0 CHECK (quantite_stock >= 0)
);

CREATE TABLE client (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    telephone VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE fournisseur (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(150) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    adresse VARCHAR(255) NOT NULL
);

CREATE TABLE commande (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES client(id),
    date_commande DATE NOT NULL DEFAULT CURRENT_DATE,
    montant_total NUMERIC(12,2) NOT NULL CHECK (montant_total >= 0),
    mode_reglement VARCHAR(50) NOT NULL CHECK (mode_reglement IN ('ESPECE','CREDIT'))
);

CREATE TABLE ligne_commande (
    id SERIAL PRIMARY KEY,
    commande_id INTEGER NOT NULL REFERENCES commande(id) ON DELETE CASCADE,
    produit_id INTEGER NOT NULL REFERENCES produit(id),
    quantite INTEGER NOT NULL CHECK (quantite > 0),
    prix_unitaire NUMERIC(12,2) NOT NULL CHECK (prix_unitaire >= 0)
);

CREATE TABLE dette (
    id SERIAL PRIMARY KEY,
    commande_id INTEGER NOT NULL UNIQUE REFERENCES commande(id) ON DELETE CASCADE,
    montant_initial NUMERIC(12,2) NOT NULL CHECK (montant_initial > 0),
    montant_restant NUMERIC(12,2) NOT NULL CHECK (montant_restant >= 0),
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('EN_COURS','SOLDEE')) DEFAULT 'EN_COURS'
);

CREATE TABLE paiement (
    id SERIAL PRIMARY KEY,
    dette_id INTEGER NOT NULL REFERENCES dette(id) ON DELETE CASCADE,
    montant NUMERIC(12,2) NOT NULL CHECK (montant > 0),
    date_paiement DATE NOT NULL DEFAULT CURRENT_DATE,
    mode_paiement VARCHAR(50) NOT NULL
);

CREATE TABLE approvisionnement (
    id SERIAL PRIMARY KEY,
    fournisseur_id INTEGER NOT NULL REFERENCES fournisseur(id),
    date_reception DATE NOT NULL DEFAULT CURRENT_DATE,
    numero_bl VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE ligne_approvisionnement (
    id SERIAL PRIMARY KEY,
    approvisionnement_id INTEGER NOT NULL REFERENCES approvisionnement(id) ON DELETE CASCADE,
    produit_id INTEGER NOT NULL REFERENCES produit(id),
    quantite_recue INTEGER NOT NULL CHECK (quantite_recue > 0),
    prix_achat_unitaire NUMERIC(12,2) NOT NULL CHECK (prix_achat_unitaire >= 0)
);