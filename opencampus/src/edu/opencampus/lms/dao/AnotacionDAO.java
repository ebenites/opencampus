package edu.opencampus.lms.dao;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import edu.opencampus.lms.excepcion.DAOException;
import edu.opencampus.lms.modelo.Anotacion;
import edu.opencampus.lms.util.Constante;

public class AnotacionDAO extends HibernateDaoSupport {

	protected Log log = LogFactory.getLog(getClass());

	public Integer insertar(Anotacion anotacion) throws DAOException {
		anotacion.setFecha_creacion(new Date());
		Anotacion a = new Anotacion();
		Object[] values = { anotacion.getUsuario(),
				anotacion.getFecha_creacion() };
		try {
			getHibernateTemplate().save(anotacion);
			getHibernateTemplate().flush();
			a = (Anotacion) getHibernateTemplate().find(
					"from Anotacion a where a.usuario = ? and a.fecha_creacion=?", values)
					.get(0);
			return a.getId();
		} catch (Exception e) {
			log.error(e.toString());
		}
		return 0;
	}

	public int eliminar(Anotacion anotacion) throws DAOException {
		int rpt = 0;
		Object[] values = { anotacion.getId(), anotacion.getUsuario() };
		try {
			Anotacion a = (Anotacion) getHibernateTemplate().find(
					"from Anotacion a where a.id = ? and a.usuario = ?",
					values).get(0);
			getHibernateTemplate().delete(a);
			rpt = 1;
		} catch (Exception e) {
			rpt = 0;
			log.error(e.toString());
		}
		return rpt;
	}

	public int actualizar(Anotacion anotacion) throws DAOException {
		int rpt = 0;
		try {
			getHibernateTemplate().update(anotacion);
			getHibernateTemplate().flush();
			rpt = 1;
		} catch (Exception e) {
			log.error(e.toString());
		}
		return rpt;
	}

	public Anotacion obtener(Anotacion anotacion) throws DAOException {
		Anotacion a = new Anotacion();
		Object[] values = { anotacion.getId(), anotacion.getUsuario() };
		try {
			a = (Anotacion) getHibernateTemplate().find(
					"from Anotacion a where a.id = ? and a.usuario = ?",
					values).get(0);
		} catch (Exception e) {
			log.error(e.toString());
			throw new DAOException("Anotacion no encontrada.");
		}
		return a;
	}

	@SuppressWarnings("unchecked")
	public List<Anotacion> obtener(int id) throws DAOException {
		List<Anotacion> anotaciones = new ArrayList<Anotacion>();
		try {
			anotaciones = getHibernateTemplate()
					.find(
							"from Anotacion a where a.usuario = ? order by a.id desc",
							id);
		} catch (DataAccessException e) {
			log.error(e.toString());
		}
		return anotaciones;
	}

	@SuppressWarnings("unchecked")
	public List<Anotacion> cargarPortada(int idUsuario) throws DAOException {
		log.info("cargarPortada(int idUsuario)");
		List<Anotacion> anotaciones = new ArrayList<Anotacion>();
		try {
			HibernateTemplate hibernate = getHibernateTemplate();
			hibernate.setMaxResults(Constante.PORTAL_CANTIDAD_ANOTACIONES);
			anotaciones = hibernate.find("from Anotacion a where a.usuario = ? order by a.id desc",idUsuario);
		} catch (DataAccessException e) {
			log.error(e.toString());
		}
		return anotaciones;
	}

}