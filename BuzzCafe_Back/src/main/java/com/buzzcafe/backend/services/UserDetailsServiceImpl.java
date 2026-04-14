package com.buzzcafe.backend.services;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.buzzcafe.backend.repositories.UserRepository;
import com.buzzcafe.backend.security.MainUser;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    private final UserRepository useRepository;

    public UserDetailsServiceImpl(UserRepository usuario) {
        this.useRepository = usuario;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return useRepository.findByUsername(username).map(MainUser::new)
                .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado"));
    }

}
