PRAGMA foreign_keys = ON;

CREATE TABLE produit (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    prix_achat REAL NOT NULL CHECK (prix_achat >= 0),
    prix_vente REAL NOT NULL CHECK (prix_vente >= 0),
    quantite_stock INTEGER NOT NULL DEFAULT 0 CHECK (quantite_stock >= 0)
);

CREATE TABLE client (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    prenom TEXT NOT NULL,
    telephone TEXT NOT NULL UNIQUE
);

CREATE TABLE fournisseur (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    telephone TEXT NOT NULL,
    adresse TEXT NOT NULL
);

CREATE TABLE commande (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL REFERENCES client(id),
    date_commande DATE NOT NULL DEFAULT CURRENT_DATE,
    montant_total REAL NOT NULL CHECK (montant_total >= 0),
    mode_reglement TEXT NOT NULL CHECK (mode_reglement IN ('ESPECE','CREDIT')),
    FOREIGN KEY (client_id) REFERENCES client(id)
);

CREATE TABLE ligne_commande (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    commande_id INTEGER NOT NULL REFERENCES commande(id) ON DELETE CASCADE,
    produit_id INTEGER NOT NULL REFERENCES produit(id),
    quantite INTEGER NOT NULL CHECK (quantite > 0),
    prix_unitaire REAL NOT NULL CHECK (prix_unitaire >= 0)
);

CREATE TABLE dette (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    commande_id INTEGER NOT NULL UNIQUE REFERENCES commande(id) ON DELETE CASCADE,
    montant_initial REAL NOT NULL CHECK (montant_initial > 0),
    montant_restant REAL NOT NULL CHECK (montant_restant >= 0),
    statut TEXT NOT NULL CHECK (statut IN ('EN_COURS','SOLDEE')) DEFAULT 'EN_COURS'
);

CREATE TABLE paiement (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dette_id INTEGER NOT NULL REFERENCES dette(id) ON DELETE CASCADE,
    montant REAL NOT NULL CHECK (montant > 0),
    date_paiement DATE NOT NULL DEFAULT CURRENT_DATE,
    mode_paiement TEXT NOT NULL
);

CREATE TABLE approvisionnement (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fournisseur_id INTEGER NOT NULL REFERENCES fournisseur(id),
    date_reception DATE NOT NULL DEFAULT CURRENT_DATE,
    numero_bl TEXT NOT NULL UNIQUE
);

CREATE TABLE ligne_approvisionnement (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    approvisionnement_id INTEGER NOT NULL REFERENCES approvisionnement(id) ON DELETE CASCADE,
    produit_id INTEGER NOT NULL REFERENCES produit(id),
    quantite_recue INTEGER NOT NULL CHECK (quantite_recue > 0),
    prix_achat_unitaire REAL NOT NULL CHECK (prix_achat_unitaire >= 0)
);