# TelecomProvider Data Analysis

This project offers a comprehensive examination of the operations of a fictional telecom provider, utilising a MySQL relational database and Python-based data visualisations.

## Project Structure

* `telecomprovider.sql` – SQL script to create and populate the database.
* `telecom_analysis.ipynb` – Jupyter Notebook that connects to the MySQL database and generates visual insights using Python.
* `er_diagram.png` – Exported image of the entity-relationship (ER) diagram illustrating the database schema.

## Features

* Connects directly to the MySQL database using SQLAlchemy.
* Visualises key metrics such as:
  * Total customers, open support tickets, unpaid subscriptions, and collected revenue.
  * Monthly revenue trends.
  * Support ticket trends over time by status.
* Clean plots using `matplotlib` and `seaborn`.

## Technologies Used

* **MySQL** – Database design and queries.
* **Python** – Data processing and visualisation.
* **Libraries**:
  * `pandas`
  * `sqlalchemy`
  * `matplotlib`
  * `seaborn`

## ER Diagram Preview

![ER Diagram](https://raw.githubusercontent.com/CleliaCaetano/TelecomProvider/main/telecomprovider_updated.png)

## Getting Started

1. Import `telecomprovider.sql` into your MySQL server.
2. Open the Jupyter Notebook.
3. Adjust database credentials if needed.
4. Run the notebook to generate visual insights.
