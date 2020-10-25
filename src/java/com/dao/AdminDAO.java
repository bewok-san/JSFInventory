/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dao;

import com.pojo.Admin;
import com.util.invUtil;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author ASUS
 */
public class AdminDAO {
    public List<Admin> alogin(String uname, String pass){
        Transaction trans = null;
        Admin adm = new Admin();
        List<Admin> admin = new ArrayList();
        
        Session session = invUtil.getSessionFactory().openSession();
        try {
            trans = session.beginTransaction();
            Query query = session.createQuery("from Admin where username=:uname and password=:pass");
            query.setString("uname", uname);
            query.setString("pass", pass);
            adm = (Admin) query.uniqueResult();
            admin = query.list();
            trans.commit();
        } catch (Exception e){
            System.out.println(e);
        } 
        session.flush();
        session.close();
        return admin;
    }
}
